variable "alb_arn" {
  type        = string
  description = "The ARN of the ALB"
}

variable "family" {
  type = string
  description = "The name of the target group family"
}

variable "container_name" {
  type = string
  description = "The name of the container to deploy"
}

variable "cluster_name" {
  type = string
  description = "The name of the cluster"
}

variable "container_image" {
  type = string
  description = "The container image to use"
}

variable "cpu" {
  type = number
  description = "The number of CPU units to allocate to the container"
}

variable "memory" {
  type = number
  description = "Memory in MB"
}

variable "container_port" {
  type = number
  description = "The port the container will be listening on"
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID"
}

variable "subnets" {
  type        = list(string)
  description = "The subnets to use for the load balancer"
}