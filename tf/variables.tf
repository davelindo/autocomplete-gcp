variable "project_name" {
  default = "gcp-autocomplete-davelindon"
}

variable "billing_account" {
  default = "015D19-501F65-01DD1F"
}

variable "region" {
  default = "us-west1"
}

variable "labels" {
  type = "map"

  default = {
    environment = "dev"
    owner       = "davelindon"
    project     = "gcp-autocomplete-davelindon"
  }
}

variable "gke_min_master_version" {
  default = "1.9.6-gke.1"
}

variable "gke_node_version" {
  default = "1.9.6-gke.1"
}
