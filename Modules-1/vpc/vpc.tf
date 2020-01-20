provider "aws" {
    region = "us-east-1"
    access_key = ""
    secret_key = "" 
}

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

resource "aws_security_group" "public_sg" {
  name   = "${var.cluster_name}-public"
  vpc_id = "${aws_vpc.vpc1.id}"

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [aws_subnet.private_subnet.cidr_block]
  }
}

resource "aws_security_group" "private_sg" {
  name   = "${var.cluster_name}-private"
  vpc_id = "${aws_vpc.vpc1.id}"

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [aws_subnet.public_subnet.cidr_block]
  }
}


