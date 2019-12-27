resource "aws_vpc" "vpc1" {
  cidr_block = "${var.vpc_cidr}"

  tags = {
    Name = "${var.vpc_name}"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id = "${aws_vpc.vpc1.id}"

  count             = "${length(var.subnet_cidr)}"
  cidr_block        = "${var.subnet_cidr}"
  availability_zone = "${element(var.azs, count.index)}"

  tags = {
    Name = "${element(var.subnet_name, count.index)}"
  }
}
