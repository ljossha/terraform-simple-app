output "access_key" {
  value = aws_iam_access_key.dev_user.id
}

output "secret_key" {
  value = aws_iam_access_key.dev_user.secret
}