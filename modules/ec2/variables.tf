variable "volume_size" {
  type        = number
  description = "The size of the volume"
}

variable "instance_type" {
  type        = string
  description = "The type of the instance"
}

variable "ami" {
  type        = string
  description = "The AMI to use"
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID"
}

variable "subnets" {
  type        = list(string)
  description = "The subnets to use"
}

variable "environment" {
  type        = string
  description = "The environment of the user"
}

variable "public_key" {
  type        = string
  description = "The public key to use"
}

variable "name" {
  type        = string
  description = "The name of the user"
}

variable "volume_size" {
  type        = number
  description = "The size of the volume"
}