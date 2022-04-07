provider "aws" {
  region = var.aws_region
}

module "s3" {
  source         = "./modules/s3"
  public_bucket  = var.public_bucket
  private_bucket = var.private_bucket
}

module "vpc" {
  source = "./modules/vpc"

  name       = "riflpw-vpc"
  cidr_block = var.vpc_cidr

  public_subnet_availability_zones = var.public_subnet_availability_zones

  private_subnet_availability_zones = var.private_subnet_availability_zones
}

module "rds" {
  source = "./modules/rds"

  name              = var.db_name
  engine            = var.db_engine
  engine_version    = var.db_version
  password          = random_string.password.result
  instance_class    = var.db_instance_class
  allocated_storage = var.db_allocated_storage
}

resource "random_string" "password" {
  length  = 10
  special = false
  upper   = false
}