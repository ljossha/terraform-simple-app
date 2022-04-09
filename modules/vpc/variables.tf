variable "public_subnet_availability_zones" {
  type        = map(string)
  description = "The availability zones for the public subnets"
}

variable "private_subnet_availability_zones" {
  type        = map(string)
  description = "The availability zones to use for the private subnets"
}

variable "cidr_block" {
  type        = string
  description = "The CIDR blocks for the public subnets"
}

variable "name" {
  type        = string
  description = "The name of the VPC"
}

variable "region" {
  type        = string
  description = "The region to create the VPC in"
}

variable "environment" {
  type        = string
  description = "The environment"
}
