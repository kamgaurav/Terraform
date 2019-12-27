resource "aws_alb_target_group" "target_group_asg" {
  name     = "${var.tg_name}"
  port     = "${var.server_port}"
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}
