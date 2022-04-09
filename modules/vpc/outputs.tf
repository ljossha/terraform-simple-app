output "vpc_id" {
  value = aws_vpc.production_vpc.id
}

output "vpc_public_subnets" {
  value = {
    for subnet in aws_subnet.public_subnet :
    subnet.id => subnet.cidr_block
  }
}

output "vpc_public_subnet_ids" {
  value = [
    for subnet in aws_subnet.public_subnet :
    subnet.id
  ]
}

output "vpc_private_subnets" {
  value = {
    for subnet in aws_subnet.private_subnet :
    subnet.id => subnet.cidr_block
  }
}

output "private_subnet_ids" {
  value = [
    for subnet in aws_subnet.private_subnet :
    subnet.id
  ]
}