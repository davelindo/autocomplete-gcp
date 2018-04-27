resource "random_string" "gke_password" {
  length  = 32
  special = false
}

resource "google_container_cluster" "gke_cluster" {
  name               = "${var.project_name}-gke"
  zone               = "${data.google_compute_zones.available.names[0]}"
  initial_node_count = 3
  project            = "${google_project.project.id}"
  min_master_version = "${var.gke_min_master_version}"
  node_version       = "${var.gke_node_version}"

  additional_zones = ["${slice(data.google_compute_zones.available.names, 1, length(data.google_compute_zones.available.*.names))}"]

  master_auth {
    username = "${var.labels["owner"]}"
    password = "${random_string.gke_password.result}"
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = "${var.labels}"
  }
}
