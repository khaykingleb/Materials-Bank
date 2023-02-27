output "dns_name" {
  value       = aws_elb.this.dns_name
  description = "DNS name of the Elastic Load Balancer"
}

output "name" {
  value       = aws_elb.this.name
  description = "Name of the Elastic Load Balancer"
}
