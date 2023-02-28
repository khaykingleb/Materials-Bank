locals {
  tags = {
    project_name = "${var.environment}-${var.project_name}"
    owner        = var.owner
  }
}

module "vpc" {
  source = "./modules/network"

  cidr_base     = var.cidr_base
  subnets_count = var.subnets_count

  environment = var.environment
  tags        = local.tags
}

module "security" {
  source = "./modules/security"

  vpc_id     = module.vpc.vpc_id
  open_ports = var.open_ports
  ssh_ips    = var.ssh_ips

  environment = var.environment
  tags        = local.tags

  depends_on = [
    module.vpc.vpc_id,
    module.vpc.public_subnets_ids,
    module.vpc.private_subnets_ids
  ]
}

module "elastic_load_balancer" {
  source = "./modules/elb"

  public_subnet_ids = module.vpc.public_subnets_ids
  public_sg_id      = module.security.public_sg_id

  environment = var.environment
  tags        = local.tags

  depends_on = [
    module.vpc.public_subnets_ids,
    module.security.public_sg_id,
  ]
}

module "autoscaling_groups" {
  source = "./modules/asg"

  public_subnet_ids  = module.vpc.public_subnets_ids
  private_subnet_ids = module.vpc.private_subnets_ids

  public_sg_id       = module.security.public_sg_id
  private_sg_id      = module.security.private_sg_id
  openssh_public_key = module.security.openssh_public_key

  elb_name = module.elastic_load_balancer.name

  ec2_instance_type = var.ec2_instance_type
  ec2_min_size      = var.ec2_min_size
  ec2_max_size      = var.ec2_max_size

  environment = var.environment
  tags        = local.tags

  depends_on = [
    module.vpc.public_subnets_ids,
    module.vpc.private_subnets_ids,
    module.security.public_sg_id,
    module.security.private_sg_id,
    module.security.ssh_key,
    module.elastic_load_balancer.name,
  ]
}
