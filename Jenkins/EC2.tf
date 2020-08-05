provider "aws" {

  	region     = "us-east-1"

}

resource "aws_instance" "web" {

	ami = "ami-0ac80df6eff0e70b5"	
	instance_type = "t2.micro"
    key_name               = "Linux"
    vpc_security_group_ids = [aws_security_group.default.id]

tags {
    	Name = "WebServer"
    }
}

resource "aws_security_group" "default" {
  name = "terraform-default-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}