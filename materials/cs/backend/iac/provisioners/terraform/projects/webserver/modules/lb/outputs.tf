output "dns_name" {
  value       = aws_lb.webserver.dns_name
  description = "DNS name of the Application Load Balancer"
}
