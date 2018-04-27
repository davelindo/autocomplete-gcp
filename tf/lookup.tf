data "google_compute_zones" "available" {
  project = "${google_project.project.id}"
}
