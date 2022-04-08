resource "aws_s3_bucket" "state" {
  bucket        = "${var.name}-terraform-state"
  force_destroy = false

  tags = {
    Provisioner = "terraform"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state" {
  bucket = aws_s3_bucket.state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_acl" "state" {
  bucket = aws_s3_bucket.state.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "state" {
  bucket = aws_s3_bucket.state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "state" {
  bucket = aws_s3_bucket.state.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "state" {
  name           = "${var.name}-terraform-state"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"

  server_side_encryption {
    enabled = true
  }

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Provisioner = "terraform"
  }
}

