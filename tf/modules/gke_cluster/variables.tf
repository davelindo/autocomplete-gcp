variable "name" {}
variable "region" {}
variable "project" {}
variable "username" {}
variable "password" {}

variable "labels" {
  default = {}
  type    = "map"
}

variable "count" {
  default = 1
}

variable "initial_node_count" {
  default = 1
}

variable "min_master_version" {
  default = "1.9.6-gke.1"
}

variable "node_version" {
  default = "1.9.6-gke.1"
}

variable "oauth_scopes" {
  default = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
    "service-control",
    "service-management",
    "https://www.googleapis.com/auth/ndev.clouddns.readwrite"
  ]
}
