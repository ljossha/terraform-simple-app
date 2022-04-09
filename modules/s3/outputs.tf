output "public_website_url" {
  value = aws_s3_bucket.public_bucket.bucket_regional_domain_name
}

output "public_website_id" {
  value = aws_s3_bucket.public_bucket.id
}

output "public_website_arn" {
  value = aws_s3_bucket.public_bucket.arn
}