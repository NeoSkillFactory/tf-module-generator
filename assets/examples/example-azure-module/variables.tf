variable "azure_region" {
  description = "Azure region for all resources"
  type        = string
  default     = "eastus"
}

variable "environment" {
  description = "Environment name (used for tagging and naming)"
  type        = string
  default     = "dev"
}

variable "resource_group_name" {
  description = "Name for the resource group"
  type        = string
  default     = "rg-${var.environment}"
}

variable "virtual_network_name" {
  description = "Name for the virtual network"
  type        = string
  default     = "vnet-${var.environment}"
}

variable "vpc_cidr" {
  description = "CIDR block for the Virtual Network"
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

variable "ssh_cidr_blocks" {
  description = "CIDR blocks allowed to SSH to VMs"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # WARNING: For demo only. Restrict in production.
}

# VM variables
variable "vm_size" {
  description = "VM size for the virtual machines"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Admin username for the VMs"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "SSH public key content (e.g., file('~/.ssh/id_rsa.pub'))"
  type        = string
  default     = ""
}

variable "admin_password" {
  description = "Admin password (use only if not using SSH keys)"
  type        = string
  default     = null
  sensitive   = true
}

# Image reference variables (used if scanner data not present)
variable "image_publisher" {
  description = "VM image publisher (e.g., Canonical)"
  type        = string
  default     = "Canonical"
}

variable "image_offer" {
  description = "VM image offer (e.g., UbuntuServer)"
  type        = string
  default     = "UbuntuServer"
}

variable "image_sku" {
  description = "VM image SKU (e.g., 22.04-LTS)"
  type        = string
  default     = "22.04-LTS"
}

variable "image_version" {
  description = "VM image version"
  type        = string
  default     = "latest"
}

# Default tags applied to all resources
variable "default_tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default = {
    Project     = "tf-module-generator-example"
    ManagedBy   = "Terraform"
    Repo        = "https://github.com/example/repo"
  }
}
