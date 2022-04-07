resource "aws_vpc" "production_vpc" {
  cidr_block = var.cidr_block

  tags = {
    Name      = var.name
    ManagedBy = "terraform"
  }
}

resource "aws_subnet" "public_subnet" {
  for_each = var.public_subnet_availability_zones

  vpc_id            = aws_vpc.production_vpc.id
  availability_zone = each.key

  cidr_block = cidrsubnet(aws_vpc.production_vpc.cidr_block, 4, each.value)

  tags = {
    ManagedBy = "terraform"
  }
}

resource "aws_subnet" "private_subnet" {
  for_each = var.private_subnet_availability_zones

  vpc_id            = aws_vpc.production_vpc.id
  availability_zone = each.key

  cidr_block = cidrsubnet(aws_vpc.production_vpc.cidr_block, 4, each.value)

  tags = {
    ManagedBy = "terraform"
  }
}