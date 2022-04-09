resource "aws_lb" "alb" {
  name               = var.name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.webdmz.id]
  subnets            = var.subnets

  tags = {
    Provisioner = "terraform"
    Environment = var.environment
  }
}

resource "aws_security_group" "webdmz" {
  name        = "${var.name}-dmz"
  description = "Allow HTTP traffic from the world"

  vpc_id = var.vpc_id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    #tfsec:ignore:aws-vpc-no-public-ingress-sgr
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS traffic from the world"
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
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
