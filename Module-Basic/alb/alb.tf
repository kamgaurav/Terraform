resource "aws_alb" "alb" {
  name               = var.alb_name
  load_balancer_type = "application"

  subnets         = var.subnet_ids
  #List of security groups
  security_groups = [aws_security_group.alb_sg.id]
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.alb.arn
  port              = local.http_port
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_alb_listener_rule" "alb_listener_rule" {
  listener_arn = aws_alb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = var.target_group_arn
  }
}

resource "aws_security_group" "alb_sg" {
  name = var.alb_name
}

resource "aws_security_group_rule" "allow_http_inbound" {
  type = "ingress"

  security_group_id = aws_security_group.alb_sg.id
  from_port         = local.http_port
  to_port           = local.http_port
  protocol          = local.tcp_protocol
  cidr_blocks       = local.all_ips
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.alb_sg.id

  from_port   = local.any_port
  to_port     = local.any_port
  protocol    = local.any_protocol
  cidr_blocks = local.all_ips
}

locals {
  http_port    = 80
  any_port     = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips      = ["0.0.0.0/0"]
}
