variable "name" {
  type        = string
  description = "The name of the load balancer"
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID"
}

variable "subnets" {
  type        = list(string)
  description = "The subnets to use for the load balancer"
}

variable "environment" {
  type        = string
  description = "The environment"
}