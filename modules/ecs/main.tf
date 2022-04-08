resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name

  configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.kms.arn
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.log_group.name
      }
    }
  }

  tags = {
    Name        = var.cluster_name,
    Provisioner = "terraform"
  }
}

resource "aws_kms_key" "kms" {
  deletion_window_in_days = 7
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "example"
}

resource "aws_ecs_task_definition" "backend_task" {
  family                   = var.family
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.container_image
      cpu       = var.cpu
      memory    = var.memory
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "service" {
  name            = var.container_name
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.backend_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnets
    security_groups  = [aws_security_group.webdmz.id]
    assign_public_ip = true
  }
}

resource "aws_security_group" "webdmz" {
  name        = "webdmz"
  description = "Allow web traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.container_port
    to_port     = var.container_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
