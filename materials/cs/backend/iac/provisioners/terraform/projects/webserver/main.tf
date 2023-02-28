locals {
  tags = {
    project_name = "${var.env}-${var.project_name}"
    owner        = var.owner
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"
  name    = "${var.env}-vpc"

  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = local.tags
}

module "security" {
  source = "./modules/security"

  vpc_id               = module.vpc.vpc_id
  ports_to_open        = var.ports_to_open
  ssh_ips              = var.ssh_ips
  ssh_private_key_path = abspath("ssh/ssh_key.pem")
  ssh_public_key_path  = abspath("ssh/ssh_key.pub")

  env  = var.env
  tags = local.tags

  depends_on = [
    module.vpc.vpc_id,
  ]
}

module "autoscaling_groups" {
  source = "./modules/asg"

  public_subnets       = module.vpc.public_subnets
  ec2_instance_type    = var.ec2_instance_type
  ec2_user_data_path   = abspath("scripts/user_data.sh")
  ec2_min_size         = var.ec2_min_size
  ec2_max_size         = var.ec2_max_size
  ec2_desired_capacity = var.ec2_desired_capacity
  ec2_instance_sg_id   = module.security.ec2_instance_sg_id
  openssh_public_key   = module.security.openssh_public_key

  env  = var.env
  tags = local.tags

  depends_on = [
    module.vpc.public_subnets,
    module.security.ec2_instance_sg_id,
    module.security.openssh_public_key
  ]
}

module "load_balancer" {
  source = "./modules/lb"

  vpc_id             = module.vpc.vpc_id
  public_subnets     = module.vpc.public_subnets
  webserver_lb_sg_id = module.security.webserver_lb_sg_id
  webserver_asg_name = module.autoscaling_groups.webserver_asg_name

  env  = var.env
  tags = local.tags

  depends_on = [
    module.vpc.vpc_id,
    module.vpc.public_subnets,
    module.security.webserver_lb_sg_id,
    module.autoscaling_groups.name,
  ]
}
