resource "aws_vpc" "vpc1" {
  cidr_block = "${var.vpc_cidr}"
  tags = {
    Name = "${var.env}-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = "${aws_vpc.vpc1.id}"
  cidr_block = "${var.public_subnet_cidr}"
  tags = {
    Name = "PublicSubnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = "${aws_vpc.vpc1.id}"
  cidr_block = "${var.private_subnet_cidr}"
  tags = {
    Name = "PrivateSubnet"
  }
}

