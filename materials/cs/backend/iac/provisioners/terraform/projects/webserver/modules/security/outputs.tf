output "webserver_lb_sg_id" {
  value       = aws_security_group.webserver_lb.id
  description = "Webserver load balancer security group ID"
}

output "ec2_instance_sg_id" {
  value       = aws_security_group.ec2_instance.id
  description = "Webserver EC2 instance security group ID"
}

output "openssh_public_key" {
  value       = tls_private_key.ssh.public_key_openssh
  description = "OpenSSH public key"
}
