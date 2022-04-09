output "ecs_sg_id" {
  value = aws_security_group.service_security_group.id
}