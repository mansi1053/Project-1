 locals {
 gcp_startup = file("${path.module}/userdata/gcp.sh")
 }

resource "google_compute_instance" "web_gcp" {
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network = var.google_compute_network.gcn1.name
    access_config { nat_ip = google_compute_address.add1.address }
  }

  metadata_startup_script = file("${path.module}/../scripts/install_nginx.sh")
}

resource "google_compute_network" "gcn1" {
  name                    = "my-network"
  auto_create_subnetworks = "true"
}

resource "google_compute_firewall" "firewall1" {
  name    = "my-firewall"
  network = google_compute_network.gcn1.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_address" "add1" {
  name   = "my-address"
  region = var.region
}