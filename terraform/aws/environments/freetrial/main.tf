terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "../../modules/aws_vpc"

  name            = "${var.environment}-vpc"
  cidr_block      = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  tags = merge(local.common_tags, var.tags)
}

module "ec2" {
  source = "../../modules/aws_ec2"

  name           = "${var.environment}-ec2"
  instance_type  = var.instance_type
  instance_count = var.instance_count
  subnet_id      = module.vpc.public_subnet_ids[0]
  vpc_id         = module.vpc.vpc_id

  tags = merge(local.common_tags, var.tags)
}

locals {
  common_tags = {
    Environment = var.environment
    Project     = "aws-saa-practice"
    ManagedBy   = "Terraform"
  }
}
