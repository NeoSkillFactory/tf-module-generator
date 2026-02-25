output "network_id" {
  description = "ID of the VPC network"
  value       = google_compute_network.main.id
}

output "network_name" {
  description = "Name of the VPC network"
  value       = google_compute_network.main.name
}

output "network_self_link" {
  description = "Self-link of the VPC network"
  value       = google_compute_network.main.self_link
}

output "subnet_ids" {
  description = "IDs of all subnets"
  value       = concat(google_compute_subnetwork.private[*].id, google_compute_subnetwork.public[*].id)
}

output "subnet_names" {
  description = "Names of all subnets"
  value       = concat(google_compute_subnetwork.private[*].name, google_compute_subnetwork.public[*].name)
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = google_compute_subnetwork.private[*].id
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = google_compute_subnetwork.public[*].id
}

output "firewall_rule_ids" {
  description = "IDs of the firewall rules"
  value = [
    google_compute_firewall.ssh.id,
    google_compute_firewall.http.id,
    google_compute_firewall.https.id,
  ]
}

output "instance_ids" {
  description = "IDs of the Compute instances"
  value       = [{{#if instanceResources}}{{#each instanceResources}}google_compute_instance.{{this.name}}.id{{#unless @last}}, {{/unless}}{{/each}}{{/if}}]
}

output "instance_private_ips" {
  description = "Private IP addresses of the instances"
  value       = [{{#if instanceResources}}{{#each instanceResources}}google_compute_instance.{{this.name}}.network_interface[0].network_ip{{#unless @last}}, {{/unless}}{{/each}}{{/if}}]
}

output "instance_public_ips" {
  description = "Public IP addresses of the instances (if assigned)"
  value       = [{{#if instanceResources}}{{#each instanceResources}}google_compute_instance.{{this.name}}.network_interface[0].access_config[0].nat_ip{{#unless @last}}, {{/unless}}{{/each}}{{/if}}]
}

output "instance_self_links" {
  description = "Self-links of the instances"
  value       = [{{#if instanceResources}}{{#each instanceResources}}google_compute_instance.{{this.name}}.self_link{{#unless @last}}, {{/unless}}{{/each}}{{/if}}]
}

output "instance_names" {
  description = "Names of the instances"
  value       = [{{#if instanceResources}}{{#each instanceResources}}google_compute_instance.{{this.name}}.name{{#unless @last}}, {{/unless}}{{/each}}{{/if}}]
}
