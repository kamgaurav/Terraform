
data "aws_availability_zones" "all" {}

resource "aws_launch_configuration" "launch_config" {
  image_id        = "ami-04763b3055de4860b"
  instance_type   = "${var.instance_type}"
  security_groups = ["${aws_security_group.instance_security_group.id}"]

  user_data = "${data.template_file.user_data.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "user_data" {
  template = "${file("${path.module}/user-data.sh")}"

  vars = {
    server_port = "${var.server_port}"
    # interpolation syntax is different, .outputs is included
    db_address = data.terraform_remote_state.db.outputs.address
    db_port    = data.terraform_remote_state.db.outputs.port
  }
}

data "terraform_remote_state" "db" {
  backend = "local"
  config = {
    path = "${var.db_remote_state_folder}"
  }
}

resource "aws_autoscaling_group" "autoscaling_group" {
  launch_configuration = "${aws_launch_configuration.launch_config.id}"
  availability_zones   = data.aws_availability_zones.all.names

  load_balancers    = ["${aws_elb.elastic_load_balancer.name}"]
  health_check_type = "ELB"

  min_size = "${var.min_size}"
  max_size = "${var.max_size}"

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}"
    propagate_at_launch = true
  }
}

resource "aws_elb" "elastic_load_balancer" {
  name               = "${var.cluster_name}"
  security_groups    = ["${aws_security_group.elb_security_group.id}"]
  availability_zones = data.aws_availability_zones.all.names

  listener {
    instance_port     = "${var.server_port}"
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:${var.server_port}/"
    interval            = 30
  }
}

resource "aws_security_group" "elb_security_group" {
  name = "${var.cluster_name}-elb"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "instance_security_group" {
  name = "${var.cluster_name}-instance"
  ingress {
    from_port   = "${var.server_port}"
    to_port     = "${var.server_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
