terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = "~> 4.0"
  }
}

##@ Application Load Balancer

resource "aws_lb" "webserver" {
  name = "${var.env}-webserver-alb"

  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = [var.webserver_lb_sg_id]

  enable_deletion_protection = false

  tags = merge(var.tags, { "Name" = "${var.env}-webserver-alb" })
}

resource "aws_lb_target_group" "webserver" {
  name = "${var.env}-webserver-alb-tg"

  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

}

resource "aws_lb_listener" "webserver" {
  load_balancer_arn = aws_lb.webserver.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webserver.arn
  }
}

resource "aws_autoscaling_attachment" "webserver" {
  autoscaling_group_name = var.webserver_asg_name
  lb_target_group_arn    = aws_lb_target_group.webserver.arn
}
