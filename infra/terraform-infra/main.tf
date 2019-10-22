provider "google" {
  credentials = "${file("../otus-k8s-storage-65e24103da13.json")}"
  project = "${var.project}"
  region = "${var.region}"
}
