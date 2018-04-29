resource "random_string" "gke_password" {
  length  = 32
  special = false
}

module "gke_cluster_west" {
  source                = "./modules/gke_cluster/"
  count                 = "${var.enable_resources}"
  initial_node_count    = 1
  machine_type          = "n1-highcpu-8"
  name                  = "${var.project_name}-${var.west_cluster_region}-gke"
  region                = "${var.west_cluster_region}"
  project               = "${google_project.project.id}"
  username              = "${var.labels["owner"]}"
  password              = "${random_string.gke_password.result}"
  labels                = "${var.labels}"
  additional_node_pools = "0"
  node_pool_node_count  = "0"
  node_pool_zone        = ["${data.google_compute_zones.available.names}"]
}

module "gke_cluster_east" {
  source = "./modules/gke_cluster/"
  count  = 0

  #count    = "${var.enable_resources}"
  name                  = "${var.project_name}-${var.east_cluster_region}-gke"
  machine_type          = "n1-highcpu-8"
  initial_node_count    = 1
  region                = "${var.east_cluster_region}"
  project               = "${google_project.project.id}"
  username              = "${var.labels["owner"]}"
  password              = "${random_string.gke_password.result}"
  labels                = "${var.labels}"
  additional_node_pools = "0"
  node_pool_zone        = ["${data.google_compute_zones.available.names}"]
}
