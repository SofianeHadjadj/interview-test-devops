terraform {
    required_providers {
      google = {
          source = "hashicorp/google"
      }
    }
}

provider "google" {
    version = "3.5.0"
    project = var.project
    region  = var.region
    zone    = var.zone
}

# Import module load-balancer

module "http-proxy" {
  source                = "./modules/http-proxy"
  name                  = var.name
  project               = var.project
  url_map               = google_compute_url_map.urlmap.self_link
  dns_managed_zone_name = var.dns_managed_zone_name
  custom_domain_names   = [var.custom_domain_name]
  create_dns_entries    = var.create_dns_entry
  dns_record_ttl        = var.dns_record_ttl
  enable_http           = var.enable_http
  enable_ssl            = var.enable_ssl
  ssl_certificates      = google_compute_ssl_certificate.certificate.*.self_link

  custom_labels = var.custom_labels
}

# Create the url map to paths backends

resource "google_compute_url_map" "urlmap" {
  project = var.project

  name        = "bink-tests-url-map"
  description = "URL map for bink-tests"

  default_service = google_compute_backend_bucket.static.self_link

  host_rule {
    hosts        = ["*"]
    path_matcher = "all"
  }

  path_matcher {
    name            = "all"
    default_service = google_compute_backend_bucket.static.self_link

    path_rule {
      paths   = ["/api", "/api/*"]
      service = google_compute_backend_service.back.self_link
    }
  }
}

# Create the backend configuration for the instance group

resource "google_compute_backend_service" "back" {
  project = var.project

  name        = "bink-tests-back"
  description = "Backend for bink-tests"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10
  enable_cdn  = false

  backend {
    group = google_compute_instance_group.group.self_link
  }

  health_checks = [google_compute_health_check.default.self_link]

  depends_on = [google_compute_instance_group.group]
}

# Configure de health check for the group backend

resource "google_compute_health_check" "default" {
  project = var.project
  name    = "bink-tests-hc"

  http_health_check {
    port         = 80
    request_path = "/api"
  }

  check_interval_sec = 5
  timeout_sec        = 5
}

# Create the storage bucket

resource "google_storage_bucket" "static" {
  project = var.project

  name          = "bink-tests-bucket"
  location      = var.static_content_bucket_location
  storage_class = "MULTI_REGIONAL"

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

# Create the backend for the bucket

resource "google_compute_backend_bucket" "static" {
  project = var.project

  name        = "bink-tests-backend-bucket"
  bucket_name = google_storage_bucket.static.name
}

# Create google certificate for the loadbalancer

resource "google_compute_ssl_certificate" "certificate" {
  project = var.project

  count = false ? 1 : 0

  name_prefix = var.name
  description = "SSL Certificate"
  private_key = join("", tls_private_key.private_key.*.private_key_pem)
  certificate = join("", tls_self_signed_cert.cert.*.cert_pem)

  lifecycle {
    create_before_destroy = true
  }
}

resource "tls_self_signed_cert" "cert" {
  count = false ? 1 : 0

  key_algorithm   = "RSA"
  private_key_pem = join("", tls_private_key.private_key.*.private_key_pem)

  subject {
    common_name  = var.custom_domain_name
    organization = "Examples, Inc"
  }

  validity_period_hours = 12

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "tls_private_key" "private_key" {
  count       = false ? 1 : 0
  algorithm   = "RSA"
  ecdsa_curve = "P256"
}


# Create backend group

resource "google_compute_instance_group" "group" {
  project   = var.project
  name      = "bink-tests-instance-group"
  zone      = var.zone
  instances = [google_compute_instance.vm-debian.self_link,google_compute_instance.vm-centos.self_link]

  lifecycle {
    create_before_destroy = true
  }

  named_port {
    name = "http"
    port = 80
  }
}

resource "google_compute_instance" "vm-debian" {
  project      = var.project
  name         = "bink-tests-instance-1"
  machine_type = "n1-standard-1"
  zone         = var.zone

  tags = ["private-app"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  metadata_startup_script = "sudo apt-get update && sudo apt-get -y install nginx && echo '<cheese-guy>Hire me, I will bring you some French cheese &#x1F9C0;</cheese-guy>' > /var/www/html/index.html"

  network_interface {
    subnetwork = "default"

    access_config {
    }
  }
}

resource "google_compute_instance" "vm-centos" {
  project      = var.project
  name         = "bink-tests-instance-2"
  machine_type = "n1-standard-1"
  zone         = var.zone
  tags = ["private-app"]

  boot_disk {
    initialize_params {
      image = "centos-7"
    }
  }

  metadata_startup_script = "sudo yum -y update && sudo yum -y install nginx && sudo systemctl start nginx && echo '<ring-guy>Hire me, I am a big fan of the lord of the rings &#x1F441;</ring-guy>' > /usr/share/nginx/html/index.html"

  network_interface {
    subnetwork = "default"
    access_config {
    }
  }
}

# Define firewall rules

resource "google_compute_firewall" "firewall" {
  project = var.project
  name    = "bink-tests-fw"
  network = "default"

# Allow the load balancer access to the instances
 
  source_ranges = ["0.0.0.0/0", "192.168.2.0/24"]

  target_tags = ["private-app"]
  source_tags = ["private-app"]

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
}