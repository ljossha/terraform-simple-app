variable "engine" {
  type        = string
  description = "The database engine to use"
}

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