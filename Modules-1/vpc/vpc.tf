resource "aws_vpc" "vpc1" {
  cidr_block = "${var.vpc_cidr}"
  tags = {
    Name = "${var.env}-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = "${aws_vpc.vpc1.id}"
  count = 2
  cidr_block = "${element(var.public_subnet_cidr, count.index)}"
  tags = {
    Name = "PublicSubnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = "${aws_vpc.vpc1.id}"
  count = 2
  cidr_block = "${element(var.private_subnet_cidr, count.index)}"
  tags = {
    Name = "PrivateSubnet"
  }
}
