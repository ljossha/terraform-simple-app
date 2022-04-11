variable "name" {
  type        = string
  description = "The name of the user"
}

variable "environment" {
  type        = string
  description = "The environment of the user"
}

variable "s3_name_public_bucket" {
  type        = string
  description = "The name of the public S3 bucket"
}

variable "s3_name_private_bucket" {
  type        = string
  description = "The name of the private S3 bucket"
}