output "database_connection" {
  value = aws_db_instance.db.endpoint
}

output "database_username" {
  value = aws_db_instance.db.username
}