terraform {
  backend "s3" {
    bucket         = "riflpw-terraform-state"
    key            = "riflpw-terraform-state/main/"
    region         = "eu-central-1"
    dynamodb_table = "riflpw-terraform-state"
    encrypt        = true
  }
}

variable "backend_s3_bucket" {
  default = "riflpw-terraform-state"
}

variable "backend_s3_key" {
  default = "riflpw-terraform-state/main/"
}

variable "backend_s3_region" {
  default = "eu-central-1"
}
