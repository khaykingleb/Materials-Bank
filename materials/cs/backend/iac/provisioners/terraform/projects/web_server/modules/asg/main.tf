terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = "~> 4.0"
  }
}

##@ EC2 Key Pair

resource "aws_key_pair" "this" {
  public_key = chomp(var.openssh_public_key)

  tags = merge(var.tags, { "name" = "${var.environment}-ec2-key-pair" })
}

##@ Launch Configurations

resource "aws_launch_configuration" "knox_fleet" { # Fort Knox Bastion Hosts
  name_prefix = "${var.environment}-knox-fleet-configuration"

  security_groups = [var.public_sg_id]

  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.ec2_instance_type
  key_name      = aws_key_pair.this.key_name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "web_fleet" { # Web Servers
  name_prefix = "${var.environment}-web-fleet-configuration"

  security_groups = [var.private_sg_id]

  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.ec2_instance_type
  user_data     = file(abspath("scripts/user_data.sh"))
  key_name      = aws_key_pair.this.key_name

  lifecycle {
    create_before_destroy = true
  }
}

##@ Autoscaling Groups

resource "aws_autoscaling_group" "knox_feet" {
  name = "${var.environment}-knox-fleet-asg"

  launch_configuration = aws_launch_configuration.knox_fleet.name
  min_size             = 1
  max_size             = 2
  desired_capacity     = 1
  health_check_type    = "EC2"
  vpc_zone_identifier  = var.public_subnet_ids
  load_balancers       = [var.elb_name]

  tag {
    key                 = "name"
    value               = "${var.environment}-fort-knox"
    propagate_at_launch = true
  }
  dynamic "tag" {
    for_each = var.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web_fleet" {
  name = "${var.environment}-web-fleet-asg"

  launch_configuration = aws_launch_configuration.web_fleet.name
  min_size             = var.ec2_min_size
  max_size             = var.ec2_max_size
  min_elb_capacity     = 2
  health_check_type    = "ELB"
  vpc_zone_identifier  = var.private_subnet_ids
  load_balancers       = [var.elb_name]

  tag {
    key                 = "name"
    value               = "${var.environment}-web-server"
    propagate_at_launch = true
  }
  dynamic "tag" {
    for_each = var.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }

}
