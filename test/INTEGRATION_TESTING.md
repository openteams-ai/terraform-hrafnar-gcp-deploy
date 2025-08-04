# Integration Testing Guide

This guide explains how to run integration tests that deploy actual infrastructure to validate the Terraform module end-to-end.

## Prerequisites

### 1. Google Cloud Platform Setup

- A GCP project with billing enabled
- Service account with the following roles:
  - `roles/run.admin`
  - `roles/sql.admin`
  - `roles/compute.networkAdmin`
  - `roles/secretmanager.admin`
  - `roles/iam.serviceAccountAdmin` 
  - `roles/resourcemanager.projectIamAdmin`
  - `roles/serviceusage.serviceUsageAdmin`

### 2. Authentication

Set up GCP authentication using one of these methods:

**Option A: Service Account Key**
```bash
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/service-account-key.json"
```

**Option B: Application Default Credentials**
```bash
gcloud auth application-default login
```

### 3. Container Image

The tests require a valid container image. You can use:
- Google's hello world image: `gcr.io/cloudrun/hello` (default)
- Your own Hrafner application image

## Required Environment Variables

Set the following environment variables before running integration tests:

```bash
# Required
export TF_VAR_project_id="your-gcp-project-id"

# Optional - defaults to hello world image
export TF_VAR_app_image="gcr.io/your-project/hrafner:latest"

# Optional - for AI functionality testing
export TF_VAR_openai_api_key="sk-your-openai-key"
export TF_VAR_anthropic_api_key="sk-ant-your-anthropic-key"

# Optional - for Cloudflare DNS testing
export TF_VAR_cloudflare_api_token="your-40-char-cloudflare-token"
export TF_VAR_cloudflare_zone_id="your-zone-id"
export TF_VAR_base_domain="yourdomain.com"
```

## Running Tests

### Individual Test Suites

```bash
# Test minimal configuration (fastest)
make test-minimal

# Test development environment 
make test-dev

# Test production environment (includes React frontend if React image provided)
make test-prod

# Run all integration tests
make test-integration
```

### Manual Test Execution

```bash
# Run specific integration test
cd test && go test -v -run TestDevEnvironmentDeployment -timeout 30m

# Run with verbose Terraform output
cd test && TF_LOG=INFO go test -v -run TestMinimalDeployment -timeout 30m
```

## Test Behavior

### Resource Lifecycle
1. Tests generate unique prefixes to avoid naming conflicts
2. Resources are created and validated
3. Resources are automatically destroyed after test completion
4. Each test runs independently with its own resources

### What Gets Tested

**TestMinimalDeployment:**
- Basic Cloud Run service deployment
- VPC and networking setup
- Cloud SQL PostgreSQL database
- Secret Manager integration
- Service accounts and IAM

**TestDevEnvironmentDeployment:**
- Development-optimized configuration
- Smaller database instance (db-f1-micro)
- No backups enabled
- Single OpenAI API key

**TestProdEnvironmentDeployment:**
- Production-scale configuration  
- Larger database instance
- Backups enabled
- Multiple AI API keys
- Optional Cloudflare DNS (if credentials provided)
- Optional React frontend (if React image provided)

## Cost Considerations

Integration tests create real GCP resources that incur costs:

- **Cloud Run**: Minimal cost for short-lived test instances
- **Cloud SQL**: db-f1-micro instances (~$7/month prorated)
- **VPC**: Free tier usage
- **Load Balancer**: ~$18/month prorated for HTTPS load balancing
- **Storage**: Minimal for database storage

**Estimated cost per test run: $0.10 - $0.50**

Tests automatically clean up resources, but ensure tests complete successfully to avoid orphaned resources.

## Troubleshooting

### Common Issues

**Authentication Errors:**
```
Error: google: could not find default credentials
```
- Ensure `GOOGLE_APPLICATION_CREDENTIALS` is set or run `gcloud auth application-default login`

**Project Permission Errors:**
```
Error: googleapi: Error 403: The caller does not have permission
```
- Verify your service account has the required IAM roles
- Check that required APIs are enabled in your GCP project

**Resource Quota Errors:**
```
Error: Quota exceeded for resource
```
- Check your GCP project quotas
- Try running tests in a different region

**Test Timeouts:**
```
Test timeout after 30m
```
- GCP resource creation can be slow
- Increase timeout: `go test -timeout 45m`
- Check GCP console for stuck resources

### Debugging Failed Tests

1. **Check Terraform State:**
   ```bash
   # Navigate to the test terraform directory
   cd test/TestMinimalDeployment*/
   tofu show
   ```

2. **Manual Cleanup:**
   ```bash
   # If automatic cleanup fails
   cd test/TestMinimalDeployment*/
   tofu destroy -auto-approve
   ```

3. **View Terraform Logs:**
   ```bash
   TF_LOG=DEBUG go test -v -run TestMinimalDeployment
   ```

## CI/CD Integration

For automated testing in CI/CD:

1. **Store GCP service account key as secret**
2. **Set required environment variables**
3. **Run subset of tests to control costs:**
   ```bash
   # Only run minimal test in CI
   make test-minimal
   ```
4. **Consider running integration tests only on releases or nightly**

## Best Practices

1. **Run tests in isolation** - Don't run multiple integration tests simultaneously
2. **Use separate GCP project** for testing to avoid conflicts
3. **Monitor costs** - Set up billing alerts for your test project  
4. **Clean up manually** if tests are interrupted
5. **Test locally first** before running in CI/CD