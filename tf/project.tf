provider "google" {
  region = "${var.region}"
}

resource "random_id" "id" {
  byte_length = "4"
  prefix      = "${var.project_name}-"
}

resource "google_project" "project" {
  name            = "${var.project_name}"
  project_id      = "${format("%.30s", random_id.id.hex)}"
  billing_account = "${var.billing_account}"
}

resource "google_project_services" "project" {
  project = "${google_project.project.project_id}"

  services = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "containerregistry.googleapis.com",
    "deploymentmanager.googleapis.com",
    "replicapool.googleapis.com",
    "replicapoolupdater.googleapis.com",
    "resourceviews.googleapis.com",
    "storage-api.googleapis.com",
    "pubsub.googleapis.com",
    "dns.googleapis.com",
  ]
}

output "project_id" {
  value = "${google_project.project.project_id}"
}
