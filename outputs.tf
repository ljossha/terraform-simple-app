output "public_website_url" {
  value = module.s3.public_website_url
}

output "database_endpoint" {
  value = module.rds.database_connection
}

output "database_password" {
  value = random_string.password.result
  sensitive = true
}

output "load_balancer_url" {
  value = module.alb.dns_name
}

output "ecr_link" {
  value = module.ecr.repository_url
}

output "cloudfront_link" {
  value = module.cloudfront.cloudfront_domain_name
}

output "user_access_key" {
  value = module.iam.access_key
  sensitive = true
}

output "user_secret_key" {
  value = module.iam.secret_key
  sensitive = true
}
