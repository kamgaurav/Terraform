locals {
  tcp_protocol = "tcp"
  all_ips      = ["0.0.0.0/0"]
}
#Web configuration
resource "aws_launch_configuration" "web_launch_config" {
  name            = "${var.web_config_name}"
  image_id        = "${var.web_ami}"
  instance_type   = "${var.web_instance_type}"
  security_groups = [aws_security_group.web_instance_sg.id]
  user_data       = "${var.web_user_data}"

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_autoscaling_group" "web_asg" {
  name                 = "${var.cluster_name}-web_asg"
  launch_configuration = aws_launch_configuration.web_launch_config.name
  vpc_zone_identifier  = "${var.public_subnet_id}"
  target_group_arns    = var.target_group_arns
  health_check_type    = "${var.health_check_type}"
  min_size             = var.min_size
  max_size             = var.max_size

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_security_group" "web_instance_sg" {
  name = "${var.cluster_name}-web_instance"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port   = "${var.server_port}"
    to_port     = "${var.server_port}"
    protocol    = local.tcp_protocol
    cidr_blocks = local.all_ips
  }
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = local.tcp_protocol
    cidr_blocks = local.all_ips
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = var.public_cidr_block
  }
}
#App configuration
resource "aws_launch_configuration" "app_launch_config" {
  name            = "${var.app_config_name}"
  image_id        = "${var.app_ami}"
  instance_type   = "${var.app_instance_type}"
  security_groups = [aws_security_group.app_instance_sg.id]
  user_data       = "${var.app_user_data}"

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_autoscaling_group" "app_asg" {
  name                 = "${var.cluster_name}-app_asg"
  launch_configuration = aws_launch_configuration.app_launch_config.name
  vpc_zone_identifier  = "${var.private_subnet_id}"
  target_group_arns    = var.target_group_arns
  health_check_type    = "${var.health_check_type}"
  min_size             = var.min_size
  max_size             = var.max_size

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_security_group" "app_instance_sg" {
  name = "${var.cluster_name}-app_instance"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port   = "${var.server_port}"
    to_port     = "${var.server_port}"
    protocol    = local.tcp_protocol
    cidr_blocks = local.all_ips
  }
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = local.tcp_protocol
    cidr_blocks = local.all_ips
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = var.private_cidr_block
  }
}
