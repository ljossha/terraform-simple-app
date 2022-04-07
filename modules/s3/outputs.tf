output "public_website_url" {
  value = aws_s3_bucket.public_bucket.website_endpoint
}