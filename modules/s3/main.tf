resource "aws_s3_bucket" "private" {
  bucket        = var.private_bucket
  force_destroy = true

  tags = {
    Provisioner = "terraform"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_acl" "private_bucket_acl" {
  bucket = aws_s3_bucket.private.id
  acl    = "private"
}

resource "aws_s3_bucket" "public_bucket" {
  bucket        = var.public_bucket
  force_destroy = true

  tags = {
    Provisioner = "terraform"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_cors_configuration" "public_bucket_cors" {
  bucket = aws_s3_bucket.public_bucket.id
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    max_age_seconds = 3600
  }
}

resource "aws_s3_bucket_website_configuration" "public_bucket_website" {
  bucket = aws_s3_bucket.public_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

data "aws_iam_policy_document" "private" {
  statement {
    actions = ["*"]

    resources = [
      "arn:aws:s3:::${var.private_bucket}/*"
    ]
  }
}

resource "aws_iam_policy" "policy" {
  name        = "S3-FullAccess-${var.private_bucket}"
  path        = "/"
  description = "Policy for accessing the private bucket"

  policy = data.aws_iam_policy_document.private.json
}
