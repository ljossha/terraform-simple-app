variable "aws_region" {
  type        = string
  description = "The AWS region to use"
}

variable "app_name" {
  type        = string
  description = "The name of the application"
}

variable "environment" {
  type        = string
  description = "The environment"
}

# S3

variable "s3_name_public_bucket" {
  type        = string
  description = "The name of the public S3 bucket"
}

variable "s3_name_private_bucket" {
  type        = string
  description = "The name of the private S3 bucket"
}

# VPC
variable "vpc_cidr" {
  type        = string
  description = "The CIDR block to use for the VPC"
}

variable "vpc_public_subnet_availability_zones" {
  type        = map(string)
  description = "The availability zones to use for the public subnets"
}

variable "vpc_private_subnet_availability_zones" {
  type        = map(string)
  description = "The availability zones to use for the private subnets"
}

# RDS
variable "db_name" {
  type        = string
  description = "The database name"
}

variable "db_allocated_storage" {
  type        = string
  description = "The database allocated storage"
  default     = "20"
}

variable "db_engine_version" {
  type        = string
  description = "The database engine version to use"
}

variable "db_instance_class" {
  type        = string
  description = "The database instance class"
}

variable "db_backup_retention_period" {
  type        = string
  description = "The database backup retention period"
  default     = "7"
}

variable "db_backup_window" {
  type        = string
  description = "The database backup window"
  default     = "07:00-09:00"
}

variable "db_maintenance_window" {
  type        = string
  description = "The database maintenance window"
  default     = "Mon:04:00-Mon:04:30"
}

# ECR

variable "ecr_repository_name" {
  type        = string
  description = "The name of the ECR repository"
}

# ALB
variable "lb_name" {
  type        = string
  description = "The name of the ALB"
}

# ECS
variable "ecr_cluster_name" {
  type        = string
  description = "The name of the ECS cluster"
}

variable "ecs_family" {
  type        = string
  description = "The name of the ECS family"
}

variable "ecs_container_name" {
  type        = string
  description = "The name of the ECS container"
}

variable "ecs_container_image" {
  type        = string
  description = "The name of the ECS container image"
}

variable "ecs_cpu" {
  type        = number
  description = "The number of CPU units to allocate"
  default     = 256
}

variable "ecs_memory" {
  type        = number
  description = "The amount of memory to allocate"
  default     = 512
}

variable "ecs_container_port" {
  type        = number
  description = "The port to expose the container on"
  default     = 80
}

# IAM
variable "username" {
  type = string
  description = "The username to use for the user"
}