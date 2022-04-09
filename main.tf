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
  source = "./modules/rds_postgres"

  name              = var.db_name
  engine_version    = var.db_engine_version
  password          = random_string.password.result
  instance_class    = var.db_instance_class
  allocated_storage = var.db_allocated_storage

  subnet_ids = module.vpc.private_subnet_ids
  ecs_sg_id  = module.ecs_cluster.ecs_sg_id
  vpc_id     = module.vpc.vpc_id

  encryption = true

  backup_retention_period = var.db_backup_retention_period # days
  backup_window           = var.db_backup_window           # UTC. Cannot overlap with maintenance_window.
  maintenance_window      = var.db_maintenance_window      # UTC. Cannot overlap with backup_window.
}

resource "random_string" "password" {
  length  = 10
  special = false
  upper   = false
}