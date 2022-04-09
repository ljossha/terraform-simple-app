variable "engine_version" {
  type        = string
  description = "The database engine version to use"
}

variable "password" {
  type        = string
  description = "The database password"
}

variable "instance_class" {
  type        = string
  description = "The database instance class"
  default     = "db.t2.micro"
}

variable "allocated_storage" {
  type        = string
  description = "The database allocated storage"
  default     = "1"
}

variable "name" {
  type        = string
  description = "The database name"
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID to use"
}

variable "ecs_sg_id" {
  type        = string
  description = "The ECS Security Group ID to use"
}

# Variables

variable "skip_final_snapshot" {
  type        = bool
  default     = false
  description = "Skip final snapshot"
}

variable "backup_retention_period" {
  type        = number
  default     = 0
  description = "The number of days to retain backups"
}

variable "backup_window" {
  type        = string
  default     = "04:00-05:00"
  description = "The daily time range for which automated backups are created"
}

variable "maintenance_window" {
  type        = string
  default     = "Mon:04:00-Mon:05:00"
  description = "The time window in UTC during which maintenance can occur"
}

variable "encryption" {
  type        = bool
  default     = false
  description = "Enable encryption at rest"
}

variable "auto_minor_version_upgrade" {
  type        = bool
  default     = true
  description = "Enable auto minor version upgrade"
}

variable "subnet_ids" {
  type        = list(string)
  description = "The subnet IDs to use"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "The environment to deploy to"
}
