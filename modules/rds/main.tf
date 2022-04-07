resource "aws_db_instance" "db" {
  allocated_storage   = var.allocated_storage
  engine              = var.engine
  engine_version      = var.engine_version
  instance_class      = var.instance_class
  identifier          = var.name
  username            = "master"
  password            = var.password
  skip_final_snapshot = true

  /* vpc_security_group_ids = var.security_groups */
}