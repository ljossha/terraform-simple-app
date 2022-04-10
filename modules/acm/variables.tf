variable "domain_name" {
  type = string
  description = "The domain name (FQDN) for the certificate"
}

variable "environment" {
  type = string
  description = "The environment to deploy to (e.g. dev, qa, prod)"
}