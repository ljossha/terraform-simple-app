resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block

  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = var.name
    Provisioner = "terraform"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Provisioner = "terraform"
    Environment = var.environment
  }
}

resource "aws_subnet" "public" {
  for_each = var.public_subnet_availability_zones

  vpc_id            = aws_vpc.vpc.id
  availability_zone = each.key

  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 4, each.value)

  tags = {
    Provisioner = "terraform"
    Environment = var.environment
  }
}

resource "aws_subnet" "private" {
  for_each = var.private_subnet_availability_zones

  vpc_id            = aws_vpc.vpc.id
  availability_zone = each.key

  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 4, each.value)

  tags = {
    Provisioner = "terraform"
    Environment = var.environment
  }
}

locals {
  public_subnet_ids = [
    for each_item in aws_subnet.public :
    each_item.id
  ]
}

resource "aws_nat_gateway" "gateway" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = local.public_subnet_ids[0]

  tags = {
    Name        = var.name
    Provisioner = "terraform"
    Environment = var.environment
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip" "nat_gateway" {
  vpc = true

  tags = {
    Name        = "${var.name}"
    Provisioner = "terraform"
    Environment = var.environment
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Provisioner = "terraform"
    Environment = var.environment
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gateway.id
  }

  tags = {
    Provisioner = "terraform"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

# VPC Endpoints

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.${var.region}.s3"

  route_table_ids = [aws_route_table.public.id, aws_route_table.private.id]

  tags = {
    Provisioner = "terraform"
    Environment = var.environment
  }
}