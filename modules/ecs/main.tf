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

  execution_role_arn = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn      = aws_iam_role.ecsTaskExecutionRole.arn
}

resource "aws_ecs_service" "service" {
  name                 = var.container_name
  cluster              = aws_ecs_cluster.cluster.id
  task_definition      = aws_ecs_task_definition.backend_task.arn
  scheduling_strategy  = "REPLICA"
  desired_count        = 1
  force_new_deployment = true
  launch_type          = "FARGATE"

  network_configuration {
    subnets = var.subnets
    security_groups = [
      aws_security_group.service_security_group.id
    ]
    assign_public_ip = true
  }
}

resource "aws_security_group" "service_security_group" {
  vpc_id = var.vpc_id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "execution-task-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}
