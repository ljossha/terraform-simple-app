resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = var.instance_type
  security_groups = [ 
    aws_security_group.allow_ssh.arn,
  ]
  subnet_id = var.subnets[0]
  key_name = aws_key_pair.deployer
  
  root_block_device {
    iops = 150
    volume_size = var.volume_size
    volume_type = "gp2"
  }

  tags = {
    Environment = var.environment
    Provisioner = "terraform"
    Name = var.name
  }
}

resource "aws_security_group" "allow_ssh" {
  vpc_id      = var.vpc_id
  description = "Allow SSH access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "ops.key"
  public_key = var.public_key != "" ? var.public_key : tls_private_key.this.public_key_pem
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
}
