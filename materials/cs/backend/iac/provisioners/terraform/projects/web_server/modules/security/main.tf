terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = "~> 4.0"
  }
}

##@ Security Groups

resource "aws_security_group" "webserver" {
  name        = "${title(var.environment)}-Webserver-SG"
  description = "Allow traffic from and to the Internet for the webserver"
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

  tags = merge(var.tags, { "Name" = "${title(var.environment)}-Webserver-SG" })
}

resource "aws_security_group" "ec2" {
  name        = "${title(var.environment)}-EC2-SG"
  description = "Security group for EC2 webservers within VPC"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = [80, 22]
    content {
      from_port       = ingress.value
      to_port         = ingress.value
      protocol        = "tcp"
      security_groups = [aws_security_group.webserver.id]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { "Name" = "${title(var.environment)}-EC2-SG" })
}
