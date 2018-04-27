resource "google_dns_managed_zone" "davelindon_me" {
  name        = "gcp-davelindon"
  dns_name    = "gcp.davelindon.me."
  description = "Hosted Zone gcp.davelindon.me"
  project     = "${google_project.project.project_id}"
}

resource "google_compute_global_address" "global_ip" {
  name       = "${var.project_name}-global-ip"
  project    = "${google_project.project.project_id}"
  ip_version = "IPV4"
}

resource "google_dns_record_set" "ingress_controller" {
  name    = "ingress.${google_dns_managed_zone.davelindon_me.dns_name}"
  type    = "A"
  ttl     = 300
  project = "${google_project.project.project_id}"

  managed_zone = "${google_dns_managed_zone.davelindon_me.name}"

  rrdatas = ["${google_compute_global_address.global_ip.address}"]
}
