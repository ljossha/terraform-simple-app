# Default
aws_region  = "eu-central-1"
app_name    = "riflpw"
environment = "dev"

# VPC
vpc_cidr = "10.0.0.0/16"

vpc_public_subnet_availability_zones  = { "eu-central-1a" : 1, "eu-central-1b" : 2, "eu-central-1c" : 3 }
vpc_private_subnet_availability_zones = { "eu-central-1a" : 4, "eu-central-1b" : 5, "eu-central-1c" : 6 }

# S3
s3_name_private_bucket = "riflpw-documents"
s3_name_public_bucket  = "riflpw-public"

# RDS
db_name                    = "riflpw"
db_engine_version          = "9.6"
db_instance_class          = "db.t3.micro"
db_allocated_storage       = "10"
db_backup_retention_period = 14                    # days
db_backup_window           = "18:30-19:00"         # UTC. Cannot overlap with db_maintenance_window.
db_maintenance_window      = "Sun:19:00-Sun:19:30" # UTC. Cannot overlap with db_backup_window.

# ECR
ecr_repository_name = "riflpw/backend"

# ALB
lb_name = "riflpw-lb"

# ECS
ecr_cluster_name    = "riflpw-ecs-cluster"
ecs_family          = "backend_task"
ecs_container_name  = "backend"
ecs_container_image = "tutum/hello-world"
ecs_cpu             = 1024
ecs_memory          = 2048
ecs_container_port  = 80

# IAM
username = "riflpw-developer"