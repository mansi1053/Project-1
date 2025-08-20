output "gcp_public_ip" {
  value = google_compute_instance.web_gcp.network_interface[0].access_config[0].nat_ip
}