data "google_compute_zones" "east" {
  project = "${google_project.project.id}"
  region  = "${var.east_cluster_region}"
}

data "google_compute_zones" "west" {
  project = "${google_project.project.id}"
  region  = "${var.west_cluster_region}"
}
