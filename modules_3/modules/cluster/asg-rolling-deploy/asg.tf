locals {
  tcp_protocol = "tcp"
  all_ips      = ["0.0.0.0/0"]

}

resource "aws_launch_configuration" "launch_config" {
  image_id        = "${var.ami}"
  instance_type   = "${var.instance_type}"
  security_groups = [aws_security_group.instance_security_group.id]

  user_data = "${var.user_data}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "instance_security_group" {
  name = "${var.cluster_name}-sg"
  ingress {
    from_port   = "${var.server_port}"
    to_port     = "${var.server_port}"
    protocol    = "local.tcp_protocol"
    cidr_blocks = local.all_ips
  }
}

resource "aws_autoscaling_group" "asg" {
  launch_configuration = aws_launch_configuration.launch_config.name
  count                = "${length(var.subnet_ids)}"
  vpc_zone_identifier  = ["${element(var.subnet_ids, count.index)}"]

  target_group_arns = ["${element(var.target_group_arns, count.index)}"]
  health_check_type = "${var.health_check_type}"

  min_size = "${var.min_size}"
  max_size = "${var.max_size}"

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-asg"
    propagate_at_launch = true
  }
}
