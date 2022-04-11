provider "aws" {
  region = var.aws_region
}

module "s3" {
  source = "./modules/s3"

  environment    = var.environment
  public_bucket  = var.s3_name_public_bucket
  private_bucket = var.s3_name_private_bucket
}

module "cloudfront" {
  source = "./modules/cloudfront"

  environment           = var.environment
  app_name              = var.app_name
  s3_website_bucket_arn = module.s3.public_website_arn
  s3_website_bucket_id  = module.s3.public_website_id
  s3_bucket_domain_name = module.s3.public_website_url
}

module "vpc" {
  source = "./modules/vpc"

  name        = "${var.app_name}-${var.environment}-vpc"
  environment = var.environment
  cidr_block  = var.vpc_cidr
  region      = var.aws_region

  public_subnet_availability_zones  = var.vpc_public_subnet_availability_zones
  private_subnet_availability_zones = var.vpc_private_subnet_availability_zones
}

module "alb" {
  source = "./modules/alb"

  name        = "${var.app_name}-${var.environment}-lb"
  environment = var.environment
  subnets     = module.vpc.public_subnet_ids
  vpc_id      = module.vpc.id
}

module "ecr" {
  source = "./modules/ecr"

  name        = var.ecr_repository_name
  environment = var.environment
}

module "ecs" {
  source = "./modules/ecs"

  name        = "${var.app_name}-${var.environment}-ecs-cluster"
  vpc_id      = module.vpc.id
  alb_arn     = module.alb.arn
  environment = var.environment

  family          = var.ecs_family
  container_name  = var.ecs_container_name
  container_image = var.ecs_container_image
  cpu             = var.ecs_cpu
  memory          = var.ecs_memory
  container_port  = var.ecs_container_port

  subnets = module.vpc.public_subnet_ids
  policies = [
    module.s3.s3_full_access_policy_arn,
  ]
}

module "rds" {
  source = "./modules/rds_postgres"

  name              = "${var.app_name}-${var.environment}-db"
  environment       = var.environment
  engine_version    = var.db_engine_version
  password          = random_string.password.result
  instance_class    = var.db_instance_class
  allocated_storage = var.db_allocated_storage

  subnet_ids = module.vpc.private_subnet_ids
  ecs_sg_id  = module.ecs.ecs_sg_id
  vpc_id     = module.vpc.id

  encryption = true

  backup_retention_period = var.db_backup_retention_period # days
  backup_window           = var.db_backup_window           # UTC. Cannot overlap with maintenance_window.
  maintenance_window      = var.db_maintenance_window      # UTC. Cannot overlap with backup_window.
}

module "iam" {
  source = "./modules/iam"

  name = var.username
  environment = var.environment

  s3_name_public_bucket = var.s3_name_public_bucket
  s3_name_private_bucket = var.s3_name_private_bucket
}

resource "random_string" "password" {
  length  = 10
  special = false
  upper   = false
}