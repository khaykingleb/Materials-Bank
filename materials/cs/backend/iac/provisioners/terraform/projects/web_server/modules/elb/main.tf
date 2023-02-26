terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = "~> 4.0"
  }
}

##@ Elastic Load Balancer (Classic Load Balancer)

resource "aws_elb" "this" {
  name = "${title(var.environment)}-Webserver-ELB"

  subnets         = var.webserver_subnet_ids
  security_groups = [var.webserver_sg_id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  tags = var.tags
}
