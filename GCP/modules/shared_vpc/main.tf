provider "google" {
  project = "terraform-309914"
  region = "us-east1"
}

resource "google_compute_network" "shared_vpc" {
    name = "shared-vpc"
    auto_create_subnetworks = false
    //shared_vpc_host = true
}

resource "google_compute_subnetwork" "public_subnet1" {
  name          = "public-subnet-1"
  description   = "public subnet 1"
  ip_cidr_range = var.cidr_block_public1
  region        = "us-east1"
  network       = google_compute_network.shared_vpc.id
}


resource "google_compute_subnetwork" "public_subnet2" {
  name          = "public-subnet-2"
  description   = "public subnet 2"
  ip_cidr_range = var.cidr_block_public2
  region        = "us-east1"
  network       = google_compute_network.shared_vpc.id
}

resource "google_compute_subnetwork" "private_subnet1" {
  name          = "private-subnet-1"
  description   = "private subnet 1"
  ip_cidr_range = var.cidr_block_private1
  region        = "us-east1"
  network       = google_compute_network.shared_vpc.id
}

resource "google_compute_subnetwork" "private_subnet2" {
  name          = "private-subnet-2"
  description   = "private subnet 2"
  ip_cidr_range = var.cidr_block_private2
  region        = "us-east1"
  network       = google_compute_network.shared_vpc.id
}
