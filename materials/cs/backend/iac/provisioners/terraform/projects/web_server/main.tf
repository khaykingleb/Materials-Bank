terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = "~> 4.0"
  }
}

provider "aws" {
  region = var.region
}

locals {
  tags = {
    full_project_name = "${var.environment}-${var.project_name}"
    owner             = var.owner
  }
}

module "vpc" {
  source = "./modules/network"

  cidr_base     = var.cidr_base
  subnets_count = var.subnets_count

  environment = var.environment
  tags        = local.tags
}

module "security_groups" {
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

  webserver_subnet_ids = module.vpc.public_subnets_ids
  webserver_sg_id      = module.security_groups.webserver_sg_id

  environment = var.environment
  tags        = local.tags

  depends_on = [
    module.vpc.public_subnets_ids,
    module.security_groups.webserver_sg_id,
  ]
}
