variable "gcp_region" {
  description = "GCP region for all resources"
  type        = string
  default     = "us-central1"
}

variable "project" {
  description = "GCP project ID (if empty, uses provider default)"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Environment name (used for labeling and naming)"
  type        = string
  default     = "dev"
}

variable "network_name" {
  description = "Name for the VPC network"
  type        = string
  default     = "network-${var.environment}"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC network (custom mode)"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "instance_count" {
  description = "Number of Compute Engine instances to create"
  type        = number
  default     = 2
}

variable "machine_type" {
  description = "Machine type for instances"
  type        = string
  default     = "e2-micro"
}

variable "image_family" {
  description = "OS image family (e.g., debian-12, ubuntu-2204-lts)"
  type        = string
  default     = "debian-12"
}

variable "image_project" {
  description = "Project containing the image (e.g., debian-cloud, ubuntu-os-cloud)"
  type        = string
  default     = "debian-cloud"
}

variable "admin_username" {
  description = "Admin username for instances"
  type        = string
  default     = "gcpuser"
}

variable "ssh_keys" {
  description = "Map of username to SSH public key content"
  type        = map(string)
  default     = {}
}

variable "assign_external_ip" {
  description = "Assign external IP to instances in public subnets"
  type        = bool
  default     = true
}

variable "ssh_cidr_blocks" {
  description = "CIDR blocks allowed to SSH (used in firewall rules)"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # WARNING: For demo only. Restrict in production.
}

variable "default_labels" {
  description = "Default labels to apply to all resources"
  type        = map(string)
  default = {
    project    = "tf-module-generator-example"
    managed-by = "Terraform"
    repo       = "https://github.com/example/repo"
  }
}
