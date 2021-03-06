# --------------------------------
# Google Compute Engine instance configuration

resource "google_compute_instance" "server" {
  count = 2
  #provider = "google-beta"

  name         = "${var.basename}-server-${count.index + 1}"
  zone         = "${var.gcp_default_region}-a"
  machine_type = "n1-standard-1"

  boot_disk {
    initialize_params {
      image = "ubuntu-1804-lts"
    }
  }

  // NOTE: The `network` is cannot work if you using "custom subnetmode network", you should set the `subnetwork` instead of the `network`.
  network_interface {
    subnetwork = module.simple-vpc.google_compute_subnetwork.main[0].self_link
    access_config {}
  }

  tags = concat(
    module.simple-vpc.google_compute_firewall.ingress-allow-ssh-from-specific-ranges.target_tags[*],
    google_compute_firewall.ingress-allow-custom-ports-from-lb.target_tags[*],
  )

  #metadata_startup_script = <<-EOF
  ##!/bin/bash -eu
  #curl -L github.com/mazgi.keys > /home/hidenori_matsuki/.ssh/authorized_keys2
  #EOF
}
