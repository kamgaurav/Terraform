

module "asg" {
  source = "../cluster"

  cluster_name = "hello-world-${var.environment}"
  ami= var.ami
  user_data = data.template_file.user_data.rendered
  instance_type = var.instance_type

  min_size = var.min_size
  max_size = var.max_size

  subnet_ids = data.aws_subnet_ids.subnet1.ids
  target_group_arns = [module.alb_tg.tg_arn]
  health_check_type = "ELB"
}

data "template_file" "user_data" {
  template = file("${path.module}/user-data.sh")

  vars = {
    server_port = var.server_port
    server_text = var.server_text
  }
}

module "alb" {
  source = "../alb"

  alb_name = "hello-world-${var.environment}"
  subnet_ids = data.aws_subnet_ids.subnet1.ids

  target_group_arn = module.alb_tg.tg_arn
}

module "alb_tg" {
  source = "../alb_tg"
  tg_name = "hello-world-${var.environment}"
  server_port= var.server_port
  vpc_id = data.aws_vpc.vpc1.id
}

data "aws_vpc" "vpc1" {
  default = true
}

data "aws_subnet_ids" "subnet1" {
  vpc_id = data.aws_vpc.vpc1.id
}