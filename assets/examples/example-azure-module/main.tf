terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.azure_region
  tags     = var.default_tags
}

# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = var.virtual_network_name
  address_space       = [var.vpc_cidr]
  location            = var.azure_region
  resource_group_name = azurerm_resource_group.main.name

  tags = var.default_tags
}

# Public IP Prefix for NAT Gateway
resource "azurerm_public_ip_prefix" "nat" {
  name                = "${var.environment}-nat-prefix"
  location            = var.azure_region
  resource_group_name = azurerm_resource_group.main.name
  prefix_length       = 31
  sku                 = "Standard"
  tags                = var.default_tags
}

# NAT Gateway
resource "azurerm_nat_gateway" "main" {
  name                = "${var.environment}-nat-gw"
  location            = var.azure_region
  resource_group_name = azurerm_resource_group.main.name
  sku_name            = "Standard"
  public_ip_prefix_ids = [azurerm_public_ip_prefix.nat.id]

  tags = var.default_tags
}

# Subnets
resource "azurerm_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  name                 = "${var.environment}-private-${count.index + 1}"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.private_subnet_cidrs[count.index]]
}

resource "azurerm_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  name                 = "${var.environment}-public-${count.index + 1}"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.public_subnet_cidrs[count.index]]
}

# Associate NAT Gateway with private subnets
resource "azurerm_subnet_nat_gateway_association" "private" {
  count = length(var.private_subnet_cidrs)

  subnet_id      = azurerm_subnet.private[count.index].id
  nat_gateway_id = azurerm_nat_gateway.main.id
}

# Network Security Group
resource "azurerm_network_security_group" "instance" {
  name                = "${var.environment}-instance-nsg"
  location            = var.azure_region
  resource_group_name = azurerm_resource_group.main.name

  {{#if ssh_cidr_blocks}}
  {{#each ssh_cidr_blocks}}
  dynamic "security_rule" {
    for_each = [1]
    content {
      name                       = "SSH-${count.index + 1000}"
      priority                   = 1000 + {{@index}}
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "{{this}}"
      destination_address_prefix = "*"
    }
  }
  {{/each}}
  {{else}}
  security_rule {
    name                       = "SSH"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  {{/if}}

  security_rule {
    name                       = "HTTP"
    priority                   = 1010
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 1020
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.default_tags
}

# Associate NSG with all subnets (public and private)
resource "azurerm_subnet_network_security_group_association" "public" {
  count = length(var.public_subnet_cidrs)

  subnet_id                 = azurerm_subnet.public[count.index].id
  network_security_group_id = azurerm_network_security_group.instance.id
}

resource "azurerm_subnet_network_security_group_association" "private" {
  count = length(var.private_subnet_cidrs)

  subnet_id                 = azurerm_subnet.private[count.index].id
  network_security_group_id = azurerm_network_security_group.instance.id
}

# Network Interfaces (if scanner provided them)
{{#if networkInterfaces}}
{{#each networkInterfaces}}
resource "azurerm_network_interface" "{{this.name}}" {
  name                = "{{this.name}}"
  location            = var.azure_region
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "{{this.subnetId}}"
    private_ip_address_allocation = "{{this.privateIpAllocation}}"
    {{#if this.publicIpAddressId}}
    public_ip_address_id          = "{{this.publicIpAddressId}}"
    {{/if}}
  }

  tags = {{json this.tags}}
}
{{/each}}
{{/if}}

# Public IPs (if scanner provided them)
{{#if publicIPs}}
{{#each publicIPs}}
resource "azurerm_public_ip" "{{this.name}}" {
  name                = "{{this.name}}"
  location            = var.azure_region
  resource_group_name = var.resource_group_name
  allocation_method   = "{{this.allocationMethod}}"
  sku                 = "{{this.sku}}"
  tags                = {{json this.tags}}
}
{{/each}}
{{/if}}

# Virtual Machines (scanner data)
{{#if vmResources}}
{{#each vmResources}}
resource "azurerm_linux_virtual_machine" "{{this.name}}" {
  name                = "{{this.name}}"
  resource_group_name = var.resource_group_name
  location            = "{{this.location}}"
  size                = "{{this.size}}"
  admin_username      = "{{this.adminUsername}}"
  network_interface_ids = [{{#each this.networkInterfaceIds}}"{{this}}"{{#unless @last}}, {{/unless}}{{/each}}]

  {{#if this.adminPassword}}
  admin_password = var.admin_password
  {{else}}
  admin_ssh_key {
    username   = "{{this.adminUsername}}"
    public_key = var.ssh_public_key
  }
  {{/if}}

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = {{this.osDisk.sizeGb 128}}
  }

  source_image_reference {
    publisher = "{{this.imageReference.publisher}}"
    offer     = "{{this.imageReference.offer}}"
    sku       = "{{this.imageReference.sku}}"
    version   = "{{this.imageReference.version}}"
  }

  {{#if this.tags}}
  tags = {{json this.tags}}
  {{/if}}
}
{{/each}}
{{/if}}
