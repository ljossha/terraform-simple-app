resource "aws_iam_user" "dev_user" {
  name = var.name
  path = "/"

  tags = {
    Environment = var.environment
    Provisioner = "terraform"
  }
}

resource "aws_iam_access_key" "dev_user" {
  user = aws_iam_user.dev_user.name
}

resource "aws_iam_user_policy" "dev_user" {
  user = aws_iam_user.dev_user.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${var.s3_name_public_bucket}",
        "arn:aws:s3:::${var.s3_name_private_bucket}"
      ]
    }
  ]
}
EOF
}