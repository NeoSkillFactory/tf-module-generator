output "resource_group_id" {
  description = "ID of the resource group"
  value       = azurerm_resource_group.main.id
}

output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_address_space" {
  description = "Address space of the VNet"
  value       = azurerm_virtual_network.main.address_space
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = azurerm_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = azurerm_subnet.private[*].id
}

output "nsg_id" {
  description = "ID of the network security group"
  value       = azurerm_network_security_group.instance.id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = azurerm_nat_gateway.main.id
}

output "vm_ids" {
  description = "IDs of the virtual machines"
  value       = [{{#if vmResources}}{{#each vmResources}}azurerm_linux_virtual_machine.{{this.name}}.id{{#unless @last}}, {{/unless}}{{/each}}{{/if}}]
}

output "vm_private_ips" {
  description = "Private IP addresses of VMs"
  value       = [{{#if vmResources}}{{#each vmResources}}azurerm_linux_virtual_machine.{{this.name}}.private_ip_address{{#unless @last}}, {{/unless}}{{/each}}{{/if}}]
}

output "vm_public_ips" {
  description = "Public IP addresses of VMs (if assigned)"
  value       = [{{#if vmResources}}{{#each vmResources}}azurerm_linux_virtual_machine.{{this.name}}.public_ip_address{{#unless @last}}, {{/unless}}{{/each}}{{/if}}]
}

output "vm_hostnames" {
  description = "VM hostnames"
  value       = [{{#if vmResources}}{{#each vmResources}}azurerm_linux_virtual_machine.{{this.name}}.computer_name{{#unless @last}}, {{/unless}}{{/each}}{{/if}}]
}
