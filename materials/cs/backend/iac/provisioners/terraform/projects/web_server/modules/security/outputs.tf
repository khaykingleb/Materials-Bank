output "public_sg_id" {
  value       = aws_security_group.public.id
  description = "Public security group ID"
}

output "private_sg_id" {
  value       = aws_security_group.private.id
  description = "Private security group ID"
}

output "openssh_public_key" {
  value       = tls_private_key.ssh.public_key_openssh
  description = "OpenSSH public key"
}
