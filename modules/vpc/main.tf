resource "aws_vpc" "production_vpc" {
  cidr_block = var.cidr_block

  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = var.name
    Provisioner = "terraform"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.production_vpc.id

  tags = {
    Provisioner = "terraform"
  }
}

resource "aws_subnet" "public_subnet" {
  for_each = var.public_subnet_availability_zones

  vpc_id            = aws_vpc.production_vpc.id
  availability_zone = each.key

  cidr_block = cidrsubnet(aws_vpc.production_vpc.cidr_block, 4, each.value)

  tags = {
    Provisioner = "terraform"
  }
}

resource "aws_subnet" "private_subnet" {
  for_each = var.private_subnet_availability_zones

  vpc_id            = aws_vpc.production_vpc.id
  availability_zone = each.key

  cidr_block = cidrsubnet(aws_vpc.production_vpc.cidr_block, 4, each.value)

  tags = {
    Provisioner = "terraform"
  }
}

locals {
  public_subnet_ids = [
    for each_item in aws_subnet.public_subnet :
    each_item.id
  ]
}

resource "aws_nat_gateway" "gateway" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = local.public_subnet_ids[0]

  tags = {
    Name        = var.name
    Provisioner = "terraform"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip" "nat_gateway" {
  vpc = true

  tags = {
    Name        = "${var.name}_nat_gateway"
    Provisioner = "terraform"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.production_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.production_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gateway.id
  }
}

resource "aws_route_table_association" "public_subnet" {
  for_each = aws_subnet.public_subnet

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_subnet" {
  for_each = aws_subnet.private_subnet

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

# VPC Endpoints

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.production_vpc.id
  service_name = "com.amazonaws.${var.region}.s3"

  route_table_ids = [aws_route_table.public.id, aws_route_table.private.id]
}