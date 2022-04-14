resource "aws_db_instance" "db" {
  identifier        = var.name
  engine            = "postgres"
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage

  username = "master"
  password = var.password

  db_subnet_group_name      = aws_db_subnet_group.group.id
  storage_encrypted         = var.encryption
  backup_retention_period   = var.backup_retention_period # days
  final_snapshot_identifier = "${var.name}-final-snapshot-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  skip_final_snapshot       = var.skip_final_snapshot
  # UTC time. Windows below cannot overlap.
  backup_window      = var.backup_window
  maintenance_window = var.maintenance_window

  vpc_security_group_ids = [
    aws_security_group.rds.id,
  ]

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  apply_immediately = false

  tags = {
    Provisioner = "terraform"
    Environment = var.environment
  }
}

resource "aws_security_group" "rds" {
  vpc_id      = var.vpc_id
  description = "Allow access to RDS"

  ingress {
    description     = "Access to database from ecs cluster"
    from_port       = 5432
    to_port         = 5432
    protocol        = "TCP"
    security_groups = [var.ecs_sg_id]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    #tfsec:ignore:aws-vpc-no-public-egress-sgr
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Provisioner = "terraform"
    Environment = var.environment
  }
}

resource "aws_db_subnet_group" "group" {
  name_prefix = "datasubnet_"
  subnet_ids  = var.subnet_ids

  tags = {
    Provisioner = "terraform"
    Environment = var.environment
  }
}