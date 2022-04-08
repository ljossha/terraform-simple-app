# Default
aws_region = "eu-central-1"

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
db_name              = "riflpw"
db_engine            = "postgres"
db_version           = "9.6"
db_instance_class    = "db.t2.micro"
db_allocated_storage = "10"

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