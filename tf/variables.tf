variable "enable_resources" {
  default = 0
}

variable "project_name" {
  default = "gcp-autocomplete-davelindon"
}

variable "billing_account" {
  default = "015D19-501F65-01DD1F"
}

variable "region" {
  default = "us-west1"
}

variable "east_cluster_region" {
  default = "us-east1"
}

variable "west_cluster_region" {
  default = "us-west1"
}

variable "enable_managed_zone" {
  default     = "1"
  description = "This value decides wether terraform will create a managed zone and a record of ingress.$managed_zone for you."
}

variable "managed_zone_name" {
  default = "gcp-davelindon"
}

variable "managed_zone_domain" {
  default = "gcp.davelindon.me."
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
