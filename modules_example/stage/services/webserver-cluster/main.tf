provider "aws" {
  region     = "us-east-1"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

resource "aws_instance" "instance" {
  ami                    = "ami-04763b3055de4860b"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.security_group.id}"]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF
  tags = {
    Name = "demo_instance"
  }
}

resource "aws_security_group" "security_group" {
  name = "demo_secgroup"
  ingress {
    from_port   = "${var.server_port}"
    to_port     = "${var.server_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
