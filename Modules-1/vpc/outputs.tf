# output "public_cidr_block" {
#   value = [aws_subnet.public_subnet.cidr_block]
#   value = aws_subnet.public_subnet[0].cidr_block
# }


output "vpc_id" {
  value = aws_vpc.vpc1.id
}

output "public_subnet_id_0" {
  # Output is not in double quotes
  value = aws_subnet.public_subnet[0].id
  
}

output "public_subnet_id_1" {
  # Output is not in double quotes
  value = aws_subnet.public_subnet[1].id
  
}

output "private_subnet_id_0" {
  value = aws_subnet.private_subnet[0].id
  
}

output "private_subnet_id_1" {
  value = aws_subnet.private_subnet[1].id
  
}