terraform {
  required_version = ">= 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  region = var.gcp_region
  project = var.project != "" ? var.project : null
}

# VPC Network
resource "google_compute_network" "main" {
  name                    = var.network_name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
  project                 = var.project != "" ? var.project : null

  description = "VPC network for ${var.environment}"
}

# Private Subnets
resource "google_compute_subnetwork" "private" {
  count = length(var.private_subnet_cidrs)

  name          = "${var.environment}-private-${count.index + 1}"
  ip_cidr_range = var.private_subnet_cidrs[count.index]
  region        = var.gcp_region
  network       = google_compute_network.main.id
  project       = var.project != "" ? var.project : null

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# Public Subnets
resource "google_compute_subnetwork" "public" {
  count = length(var.public_subnet_cidrs)

  name          = "${var.environment}-public-${count.index + 1}"
  ip_cidr_range = var.public_subnet_cidrs[count.index]
  region        = var.gcp_region
  network       = google_compute_network.main.id
  project       = var.project != "" ? var.project : null

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# Firewall rule: allow SSH
resource "google_compute_firewall" "ssh" {
  name    = "${var.environment}-allow-ssh"
  network = google_compute_network.main.name
  project = var.project != "" ? var.project : null

  direction = "INGRESS"
  priority  = 1000

  dynamic "source_ranges" {
    for_each = [var.ssh_cidr_blocks]
    content {
      value = source_ranges.value
    }
  }

  target_tags = ["ssh"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

# Firewall rule: allow HTTP
resource "google_compute_firewall" "http" {
  name    = "${var.environment}-allow-http"
  network = google_compute_network.main.name
  project = var.project != "" ? var.project : null

  direction = "INGRESS"
  priority  = 1010

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http"]

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
}

# Firewall rule: allow HTTPS
resource "google_compute_firewall" "https" {
  name    = "${var.environment}-allow-https"
  network = google_compute_network.main.name
  project = var.project != "" ? var.project : null

  direction = "INGRESS"
  priority  = 1020

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["https"]

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
}

# Compute Engine Instances (from scanner data)
{{#if instanceResources}}
{{#each instanceResources}}
resource "google_compute_instance" "{{this.name}}" {
  name         = "{{this.name}}"
  machine_type = "{{this.machineType}}"
  zone         = "{{this.zone}}"
  project      = var.project != "" ? var.project : null

  {{#if this.canIpForward}}
  can_ip_forward = {{json this.canIpForward}}
  {{/if}}

  {{#if this.tags}}
  labels = {{json merge this.tags var.default_labels}}
  {{else}}
  labels = var.default_labels
  {{/if}}

  tags = {{json this.tags}}

  boot_disk {
    initialize_params {
      {{#if this.bootImage}}
      image = "{{this.bootImage}}"
      {{else}}
      size  = {{this.bootDisk.sizeGb 50}}
      type  = "{{this.bootDisk.type 'pd-standard'}}"
      {{/if}}
    }
  }

  {{#each this.networkInterfaces}}
  network_interface {
    {{#if this.networkIP}}
    network_ip = "{{this.networkIP}}"
    {{/if}}

    subnetwork = "{{this.subnetwork}}"

    {{#if this.accessConfigs}}
    dynamic "access_config" {
      for_each = {{json this.accessConfigs}}
      content {
        nat_ip = access_config.nat_ip
      }
    }
    {{/if}}
  }
  {{/each}}

  {{#if this.metadata}}
  metadata = {
    {{#each this.metadata}}
    {{@key}} = "{{this}}"
    {{/each}}
  }
  {{/if}}

  {{#if this.serviceAccount}}
  service_account {
    email  = "{{this.serviceAccount.email}}"
    scopes = {{json this.serviceAccount.scopes}}
  }
  {{/if}}
}
{{/each}}
{{/if}}
