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
