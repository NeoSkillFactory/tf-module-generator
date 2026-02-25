output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "vpc_default_security_group_id" {
  description = "Default security group ID of the VPC"
  value       = aws_vpc.main.default_security_group_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}

output "private_route_table_ids" {
  description = "IDs of the private route tables"
  value       = aws_route_table.private[*].id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "nat_gateway_ids" {
  description = "IDs of the NAT Gateways"
  value       = aws_nat_gateway.main[*].id
}

output "nat_gateway_public_ips" {
  description = "Public IP addresses of NAT Gateways"
  value       = aws_eip.nat[*].public_ip
}

output "instance_ids" {
  description = "IDs of the EC2 instances"
  value       = aws_instance.example[*].id
}

output "instance_arns" {
  description = "ARNs of the EC2 instances"
  value       = aws_instance.example[*].arn
}

output "instance_public_ips" {
  description = "Public IP addresses of EC2 instances"
  value       = aws_instance.example[*].public_ip
}

output "instance_private_ips" {
  description = "Private IP addresses of EC2 instances"
  value       = aws_instance.example[*].private_ip
}

output "instance_hostnames" {
  description = "Private DNS names of EC2 instances"
  value       = aws_instance.example[*].private_dns_name
}

output "instance_public_dns" {
  description = "Public DNS names of EC2 instances"
  value       = aws_instance.example[*].public_dns
}

output "security_group_id" {
  description = "ID of the instance security group"
  value       = aws_security_group.instance.id
}

output "security_group_vpc_id" {
  description = "VPC ID of the security group"
  value       = aws_security_group.instance.vpc_id
}
