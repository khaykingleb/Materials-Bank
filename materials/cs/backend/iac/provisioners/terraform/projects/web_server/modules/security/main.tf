terraform {
  required_version = ">= 1.3"
  required_providers {
    aws   = "~> 4.0"
    tls   = "~> 4.0"
    local = "~> 2.3"
  }
}

##@ Security Groups

resource "aws_security_group" "public" {
  name        = "${var.environment}-Public-SG"
  description = "Allow traffic from and to the Internet"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.open_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_ips
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { "name" = "${var.environment}-Webserver-SG" })
}

resource "aws_security_group" "private" {
  name        = "${var.environment}-Private-SG"
  description = "Security group for EC2 webservers within VPC"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = [80, 22]
    content {
      from_port       = ingress.value
      to_port         = ingress.value
      protocol        = "tcp"
      security_groups = [aws_security_group.public.id]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { "name" = "${var.environment}-EC2-SG" })
}


##@ SSH Key

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content         = tls_private_key.ssh.private_key_pem
  filename        = abspath("ssh/${var.environment}_ssh_key.pem")
  file_permission = "0400"
}

resource "local_file" "public_key" {
  content  = tls_private_key.ssh.public_key_openssh
  filename = abspath("ssh/${var.environment}_ssh_key.pub")
}
