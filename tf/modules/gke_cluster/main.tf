resource "google_container_cluster" "gke_cluster" {
  name               = "${var.name}"
  count              = "${var.count}"
  region             = "${var.region}"
  initial_node_count = "${var.initial_node_count}"
  project            = "${var.project}"
  min_master_version = "${var.min_master_version}"
  node_version       = "${var.node_version}"

  master_auth {
    username = "${var.username}"
    password = "${var.password}"
  }

  node_config {
    oauth_scopes = ["${var.oauth_scopes}"]

    labels = "${var.labels}"
  }
}
