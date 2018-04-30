resource "google_dns_managed_zone" "managed_zone" {
  count       = "${var.enable_managed_zone}"
  name        = "${var.managed_zone_name}"
  dns_name    = "${var.managed_zone_domain}"
  description = "Hosted Zone ${var.managed_zone_domain}"
  project     = "${google_project.project.project_id}"
}

resource "google_compute_global_address" "global_ip" {
  count = "${var.enable_resources}"

  name       = "${var.project_name}-global-ip"
  project    = "${google_project.project.project_id}"
  ip_version = "IPV4"
}

resource "google_dns_record_set" "ingress_controller" {
  count   = "${var.enable_resources * var.enable_managed_zone}"
  name    = "ingress.${google_dns_managed_zone.managed_zone.dns_name}"
  type    = "A"
  ttl     = 300
  project = "${google_project.project.project_id}"

  managed_zone = "${google_dns_managed_zone.managed_zone.name}"

  rrdatas = ["${google_compute_global_address.global_ip.address}"]
}
