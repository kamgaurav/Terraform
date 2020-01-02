resource "aws_launch_configuration" "launch_conf" {
  image_id        = var.ami
  instance_type   = var.instance_type
  security_groups = [aws_security_group.instance_sg.id]
  user_data       = var.user_data

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name = "${var.cluster_name}-asg"

  launch_configuration = aws_launch_configuration.launch_conf.name

  vpc_zone_identifier = var.subnet_ids

  target_group_arns = var.target_group_arns
  health_check_type = var.health_check_type

  min_size = var.min_size
  max_size = var.max_size

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "instance_sg" {
    name = "${var.cluster_name}-instance"  
}

resource "aws_security_group_rule" "allow_server_http_inbound" {
  type = "ingress"
  security_group_id = aws_security_group.instance_sg.id

  from_port = var.server_port
  to_port = var.server_port
  protocol = local.tcp_protocol
  cidr_blocks = local.all_ips
}

locals {
    tcp_protocol = "tcp"
    all_ips = ["0.0.0.0/0"]
}



