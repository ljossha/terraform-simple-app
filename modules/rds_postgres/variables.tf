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
  type    = bool
  default = false
}

variable "backup_retention_period" {
  type    = number
  default = 0
}

variable "backup_window" {
  type    = string
  default = "04:00-05:00"
}

variable "maintenance_window" {
  type    = string
  default = "Mon:04:00-Mon:05:00"
}

variable "encryption" {
  type    = bool
  default = false
}

variable "auto_minor_version_upgrade" {
  type    = bool
  default = true
}

variable "subnet_ids" {
  type = list(string)
}

variable "environment" {
  type    = string
  default = "dev"
}
