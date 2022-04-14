output "id" {
  value = aws_vpc.vpc.id
}

output "public_subnets" {
  value = {
    for subnet in aws_subnet.public :
    subnet.id => subnet.cidr_block
  }
}

output "public_subnet_ids" {
  value = [
    for subnet in aws_subnet.public :
    subnet.id
  ]
}

output "private_subnets" {
  value = {
    for subnet in aws_subnet.private :
    subnet.id => subnet.cidr_block
  }
}

output "private_subnet_ids" {
  value = [
    for subnet in aws_subnet.private :
    subnet.id
  ]
}