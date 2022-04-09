# Default
aws_region = "eu-central-1"
app_name = "riflpw"

# VPC
vpc_cidr = "10.0.0.0/16"

public_subnet_availability_zones  = { "eu-central-1a" : 1, "eu-central-1b" : 2, "eu-central-1c" : 3 }
private_subnet_availability_zones = { "eu-central-1a" : 4, "eu-central-1b" : 5, "eu-central-1c" : 6 }

# EC2
instance_type = "t2.micro"
instance_ami  = "ami-0b9c9d9b"
instance_disk = "20"

# S3
private_bucket = "riflpw-documents"
public_bucket  = "riflpw-public"

# RDS
db_name                    = "riflpw"
db_engine                  = "postgres"
db_engine_version          = "9.6"
db_instance_class          = "db.t3.micro"
db_allocated_storage       = "10"
db_backup_retention_period = 14                    # days
db_backup_window           = "18:30-19:00"         # UTC. Cannot overlap with db_maintenance_window.
db_maintenance_window      = "Sun:19:00-Sun:19:30" # UTC. Cannot overlap with db_backup_window.

# ECR
repository_name = "riflpw/backend"

# ALB
lb_name = "riflpw-lb"

# ECS
family          = "backend_task"
container_name  = "backend"
container_image = "tutum/hello-world"
cpu             = 1024
memory          = 2048
container_port  = 80