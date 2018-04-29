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
    machine_type = "${var.machine_type}"
    preemptible  = "${var.preemptible}"
    labels       = "${var.labels}"
  }
}

resource "google_container_node_pool" "additional_node_pool" {
  count      = "${var.additional_node_pools}"
  project    = "${var.project}"
  name       = "gke-${replace(google_container_cluster.gke_cluster.endpoint,".","-")}-${element(var.node_pool_zone,count.index)}"
  zone       = "${element(var.node_pool_zone,count.index)}"
  cluster    = "${google_container_cluster.gke_cluster.name}"
  node_count = "${var.node_pool_node_count}"
}
