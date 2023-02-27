terraform {
  required_version = ">= 1.3"
  required_providers {
    aws   = "~> 4.0"
    tls   = "~> 4.0"
    local = "~> 2.3"
  }
}

provider "aws" {
  region = var.region
}

provider "tls" {}

provider "local" {}
