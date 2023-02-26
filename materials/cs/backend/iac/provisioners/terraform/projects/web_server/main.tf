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
