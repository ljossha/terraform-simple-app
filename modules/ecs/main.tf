resource "aws_ecs_cluster" "cluster" {
  name = var.name

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
    Name        = var.name,
    Provisioner = "terraform"
    Environment = var.environment
  }
}

resource "aws_kms_key" "kms" {
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Provisioner = "terraform"
    Environment = var.environment
  }
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "/aws/ecs/${var.name}"

  tags = {
    Provisioner = "terraform"
    Environment = var.environment
  }
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

  tags = {
    Provisioner = "terraform"
    Environment = var.environment
  }
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

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = var.container_name
    container_port   = 80
  }

  tags = {
    Provisioner = "terraform"
    Environment = var.environment
  }
}

resource "aws_security_group" "service_security_group" {
  vpc_id      = var.vpc_id
  description = "Allow HTTP access to the ECS service"

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "TCP"
    #tfsec:ignore:aws-vpc-no-public-ingress-sgr
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP traffic from the world"
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    #tfsec:ignore:aws-vpc-no-public-egress-sgr
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Provisioner = "terraform"
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "target_group" {
  name        = "tg"
  port        = var.container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    healthy_threshold   = "3"
    interval            = "300"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }

  tags = {
    Provisioner = "terraform"
    Environment = var.environment
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = var.alb_arn
  port              = 80
  /* TODO: Change HTTP to HTTPS when SSL will be implemented */
  #tfsec:ignore:aws-elb-http-not-used
  protocol = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.id
  }

  tags = {
    Provisioner = "terraform"
    Environment = var.environment
  }
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "execution-task-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  tags = {
    Provisioner = "terraform"
    Environment = var.environment
  }
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

resource "aws_iam_role_policy_attachment" "role-policy-attachment" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = var.policies[0]
}
