locals {
  http_port    = 80
  https_port   = 443
  any_port     = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips      = ["0.0.0.0/0"]
}

# Alb creation will fail, if there is no internet gateway attached
resource "aws_alb" "web_alb" {
  name               = "${var.web_alb_name}"
  internal           = false
  load_balancer_type = "application"
  subnets            = "${var.public_subnet_id}"

  #List of security groups
  security_groups = [aws_security_group.web_alb_sg.id]
}

resource "aws_alb_listener" "web_http" {
  count             = contains(var.apps, "web") ? 1 : 0
  load_balancer_arn = aws_alb.web_alb.arn
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

resource "aws_alb_listener_rule" "web_listener_rule" {
  listener_arn = aws_alb_listener.web_http[0].arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = var.web_target_group_arn
  }
}

resource "aws_security_group" "web_alb_sg" {
  name = "${var.web_alb_name}"

  ingress {
    from_port   = local.http_port
    to_port     = local.http_port
    protocol    = local.tcp_protocol
    cidr_blocks = local.all_ips
  }
  ingress {
    from_port   = local.https_port
    to_port     = local.https_port
    protocol    = local.tcp_protocol
    cidr_blocks = local.all_ips
  }
  egress {
    from_port   = local.any_port
    to_port     = local.any_port
    protocol    = local.any_protocol
    cidr_blocks = local.all_ips
  }

}

resource "aws_alb" "app_alb" {
  name               = "${var.app_alb_name}"
  internal           = false
  load_balancer_type = "application"
  subnets            = "${var.private_subnet_id}"

  #List of security groups
  security_groups = [aws_security_group.app_alb_sg.id]
}

resource "aws_alb_listener" "app_http" {
  count             = contains(var.apps, "app") ? 1 : 0
  load_balancer_arn = aws_alb.app_alb.arn
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

resource "aws_alb_listener_rule" "app_listener_rule" {
  listener_arn = aws_alb_listener.app_http[0].arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = var.app_target_group_arn
  }
}

resource "aws_security_group" "app_alb_sg" {
  name = "${var.app_alb_name}"

  ingress {
    from_port   = local.http_port
    to_port     = local.http_port
    protocol    = local.tcp_protocol
    cidr_blocks = local.all_ips
  }
  ingress {
    from_port   = local.https_port
    to_port     = local.https_port
    protocol    = local.tcp_protocol
    cidr_blocks = local.all_ips
  }
  egress {
    from_port   = local.any_port
    to_port     = local.any_port
    protocol    = local.any_protocol
    cidr_blocks = local.all_ips
  }

}

