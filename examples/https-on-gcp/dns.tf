resource "google_dns_managed_zone" "main" {
  name     = "${var.basename}-main"
  dns_name = "${var.basedomain}."
  dnssec_config {
    state = "on"
  }
}
