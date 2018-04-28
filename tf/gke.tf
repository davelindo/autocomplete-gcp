resource "random_string" "gke_password" {
  length  = 32
  special = false
}

module "gke_cluster_west" {
  source   = "./modules/gke_cluster/"
  count    = "${var.enable_resources}"
  name     = "${var.project_name}-${var.west_cluster_region}-gke"
  region   = "${var.west_cluster_region}"
  project  = "${google_project.project.id}"
  username = "${var.labels["owner"]}"
  password = "${random_string.gke_password.result}"
  labels   = "${var.labels}"
}

module "gke_cluster_east" {
  source   = "./modules/gke_cluster/"
  count = 0
  #count    = "${var.enable_resources}"
  name     = "${var.project_name}-${var.east_cluster_region}-gke"
  region   = "${var.east_cluster_region}"
  project  = "${google_project.project.id}"
  username = "${var.labels["owner"]}"
  password = "${random_string.gke_password.result}"
  labels   = "${var.labels}"
}
