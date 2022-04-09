output "id" {
  value = aws_vpc.production_vpc.id
}

output "public_subnets" {
  value = {
    for subnet in aws_subnet.public_subnet :
    subnet.id => subnet.cidr_block
  }
}

output "public_subnet_ids" {
  value = [
    for subnet in aws_subnet.public_subnet :
    subnet.id
  ]
}

output "private_subnets" {
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