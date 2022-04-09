variable "s3_website_bucket_arn" {
  type = string
  description = "The ARN of the S3 bucket to use for the website"
}

variable "s3_website_bucket_id" {
  type = string
  description = "The ID of the S3 bucket to use for the website"
}

variable "s3_bucket_domain_name" {
  type = string
  description = "The domain name of the S3 bucket to use for the website"
}

variable "app_name" {
  type = string
  description = "The name of the application"
}

variable "environment" {
  type = string
  description = "The environment of the application"
}