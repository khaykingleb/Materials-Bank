output "vpc_id" {
  value       = aws_vpc.this.id
  description = "VPC ID"
}

output "public_subnets_ids" {
  value       = aws_subnet.public[*].id
  description = "Public subnet IDs"
}

output "private_subnets_ids" {
  value       = aws_subnet.private[*].id
  description = "Private subnet IDs"
}
