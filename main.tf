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
  region     = var.aws_region

  public_subnet_availability_zones = var.public_subnet_availability_zones

  private_subnet_availability_zones = var.private_subnet_availability_zones
}

module "alb" {
  source = "./modules/alb"

  lb_name = var.lb_name
  subnets = module.vpc.vpc_public_subnet_ids
  vpc_id  = module.vpc.vpc_id
}

module "ecr_backend" {
  source = "./modules/ecr"

  repository_name = var.repository_name
}

module "ecs_cluster" {
  source = "./modules/ecs"

  cluster_name = "test_cluster"
  vpc_id       = module.vpc.vpc_id
  alb_arn      = module.alb.alb_arn

  family          = var.family
  container_name  = var.container_name
  container_image = var.container_image
  cpu             = var.cpu
  memory          = var.memory
  container_port  = var.container_port

  subnets = module.vpc.vpc_public_subnet_ids
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