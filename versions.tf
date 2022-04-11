terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.1.2"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "4.9.0"
    }
  }

  required_version = ">= 1.1.0"
}