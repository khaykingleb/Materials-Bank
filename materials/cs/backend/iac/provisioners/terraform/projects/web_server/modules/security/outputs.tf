output "webserver_sg_id" {
  value       = aws_security_group.webserver.id
  description = "Security group ID for webserver"
}

output "ec2_sg_id" {
  value       = aws_security_group.ec2.id
  description = "Security group ID for EC2s"
}
