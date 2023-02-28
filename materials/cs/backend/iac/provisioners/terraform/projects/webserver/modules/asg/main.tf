terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = "~> 4.0"
  }
}

##@ EC2 Key Pair

resource "aws_key_pair" "ec2" {
  public_key = chomp(var.openssh_public_key)

  tags = merge(var.tags, { "Name" = "${var.env}-ec2-key-pair" })
}

##@ Launch Configurations

resource "aws_launch_configuration" "webserver" {
  name_prefix = "${var.env}-webserver-lc-"

  security_groups = [var.ec2_instance_sg_id]

  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.ec2_instance_type
  user_data     = file(var.ec2_user_data_path)
  key_name      = aws_key_pair.ec2.key_name

  lifecycle {
    create_before_destroy = true
  }
}

##@ Autoscaling Groups

resource "aws_autoscaling_group" "webserver" {
  name = "${var.env}-webserver-asg"

  min_size             = var.ec2_min_size
  max_size             = var.ec2_max_size
  desired_capacity     = var.ec2_desired_capacity
  launch_configuration = aws_launch_configuration.webserver.name

  vpc_zone_identifier = var.public_subnets

  tag {
    key                 = "Name"
    value               = "${var.env}-webserver-asg"
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
}
