#Application load balancer
locals {
  http_port    = 80
  any_port     = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips      = ["0.0.0.0/0"]
}

resource "aws_lb" "load_balancer" {
  name               = "${var.alb_name}-alb"
  load_balancer_type = "application"
  subnets            = "${var.subnet_ids}"
  security_groups    = [aws_security_group.alb.id]
}

#Load balancer listener resource
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = local.http_port
  protocol          = "HTTP"

  #By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

#Load balancer listener rule
resource "aws_lb_listener_rule" "listener_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = "${var.target_group_arns}"
  }
}

# Security group for application load balancer
resource "aws_security_group" "alb" {
  name = "${var.alb_name}-alb"

  #Allow inbound HTTP requests
  ingress {
    from_port   = local.http_port
    to_port     = local.http_port
    protocol    = local.tcp_protocol
    cidr_blocks = local.all_ips
  }

  egress {
    #from "any port- 0 to any port - 0"
    from_port = local.any_port
    to_port   = local.any_port
    #any protocol "-1"
    protocol    = local.tcp_protocol
    cidr_blocks = local.all_ips
  }
}
