variable "alb_arn" {
  type        = string
  description = "The ARN of the ALB"
}

variable "family" {
  type = string
}

variable "container_name" {

}

variable "cluster_name" {
  type = string
}

variable "container_image" {
  type = string
}

variable "cpu" {
  type = number
}

variable "memory" {
  type = number
}

variable "container_port" {
  type = number
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID"
}

variable "subnets" {
  type        = list(string)
  description = "The subnets to use for the load balancer"
}