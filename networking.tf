# VPC Network
resource "google_compute_network" "main" {
  name                    = local.vpc_name
  auto_create_subnetworks = false
  project                 = var.project_id
}

# Private subnet for database and internal resources
resource "google_compute_subnetwork" "private" {
  name          = local.private_subnet_name
  ip_cidr_range = var.private_subnet_cidr
  region        = var.region
  network       = google_compute_network.main.id
  project       = var.project_id

  # Enable private Google access for accessing Google APIs
  private_ip_google_access = true
}

# Cloud Router for NAT Gateway
resource "google_compute_router" "main" {
  count   = var.enable_nat_gateway ? 1 : 0
  name    = local.router_name
  region  = var.region
  network = google_compute_network.main.id
  project = var.project_id
}

# Cloud NAT for outbound internet access
resource "google_compute_router_nat" "main" {
  count   = var.enable_nat_gateway ? 1 : 0
  name    = local.nat_gateway_name
  router  = google_compute_router.main[0].name
  region  = var.region
  project = var.project_id

  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

# Firewall rule to allow health checks for Cloud Run
resource "google_compute_firewall" "allow_health_checks" {
  name    = "${local.resource_prefix}-allow-health-checks"
  network = google_compute_network.main.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  # Google Cloud health check source ranges
  source_ranges = [
    "130.211.0.0/22",
    "35.191.0.0/16"
  ]

  target_tags = ["cloud-run-health-check"]
}

# Firewall rule for internal VPC communication
resource "google_compute_firewall" "allow_internal" {
  name    = "${local.resource_prefix}-allow-internal"
  network = google_compute_network.main.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443", "5432", "8080"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = [var.vpc_cidr]
}
