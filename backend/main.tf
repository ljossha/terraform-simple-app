provider "aws" {
  region = var.region
}

# Backend
module "terraform_backend" {
  source = "../modules/backend"

  name = var.name
}

