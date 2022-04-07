variable "aws_region" {
  type        = string
  description = "The AWS region to use"
}

variable "public_bucket" {
  type        = string
  description = "The name of the public S3 bucket"
}

variable "private_bucket" {
  type        = string
  description = "The name of the private S3 bucket"
}

# VPC
variable "vpc_cidr" {
  type        = string
  description = "The CIDR block to use for the VPC"
}

variable "public_subnet_availability_zones" {
  type        = map(string)
  description = "The availability zones to use for the public subnets"
}

variable "private_subnet_availability_zones" {
  type        = map(string)
  description = "The availability zones to use for the private subnets"
}

# RDS
variable "db_name" {
  type        = string
  description = "The database name"
}

variable "db_engine" {
  type        = string
  description = "The database engine to use"
  default     = "mysql"
}

variable "db_version" {
  type        = string
  description = "The database engine version to use"
  default     = "5.7"
}

variable "db_allocated_storage" {
  type        = string
  description = "The database allocated storage"
  default     = "1"
}

variable "db_engine_version" {
  type        = string
  description = "The database engine version to use"
  default     = "5.7"
}

variable "db_instance_class" {
  type        = string
  description = "The database instance class"
  default     = "db.t2.micro"
}