variable "public_bucket" {
  type        = string
  description = "The name of the public S3 bucket"
}

variable "private_bucket" {
  type        = string
  description = "The name of the private S3 bucket"
}

variable "environment" {
  type        = string
  description = "The environment"
}