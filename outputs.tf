output "public_website_url" {
  value = module.s3.public_website_url
}

output "database_endpoint" {
  value = module.rds.database_connection
}

output "database_password" {
  value = random_string.password.result
}
