output "public_cidr_block" {
  value = aws_subnet.public_subnet.cidr_block
  #value = aws_subnet.public_subnet[0].cidr_block
}

output "private_cidr_block" {
  value = "aws_subnet.private_subnet.cidr_block"
}

output "vpc_id" {
  value = "aws_vpc.vpc1.id"
}

output "public_subnet_id" {
  value = "aws_subnet.public_subnet.id"
  
}

output "private_subnet_id" {
  value = "aws_subnet.private_subnet.id"
  
}