data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

module "target_group_asg" {
  source = "../../networking/alb_targets"

  tg_name     = "Target1"
  server_port = "8080"
  vpc_id      = data.aws_vpc.default.id
}

module "asg" {
  source = "../../cluster/asg-rolling-deploy"

  cluster_name  = "Sprk-$(var.environment)"
  ami           = "${var.ami}"
  user_data     = data.template_file.user_data.rendered
  instance_type = "${var.instance_type}"

  min_size = "${var.min_size}"
  max_size = "${var.max_size}"

  subnet_ids        = data.aws_subnet_ids.default.ids
  target_group_arns = ["module.target_group_asg.target_group_arn"]
  health_check_type = "ELB"
  tg_name           = "Target1"
}

data "template_file" "user_data" {
  template = "${file("${path.module}/user-data.sh")}"

  vars = {
    server_port = "${var.server_port}"
    # interpolation syntax is different, .outputs is included
    #db_address = data.terraform_remote_state.db.outputs.address
    #db_port    = data.terraform_remote_state.db.outputs.port
  }
}

module "alb" {
  source = "../../networking/alb"

  alb_name          = "hello-world-${var.environment}"
  subnet_ids        = data.aws_subnet_ids.default.ids
  tg_name           = "Target1"
  target_group_arns = module.target_group_asg.target_group_arn
}

/*module "vpc" {
  source = "../../networking/vpc"

  vpc_cidr    = "10.0.0.0/16"
  vpc_name    = "Dev_VPC"
  azs         = ["us-east-1a", "us-east-1b", ]
  subnet_cidr = ["10.0.1.0/24", "10.0.2.0/24"]
  subnet_name = ["Public_Subnet", "Private_Subnet"]
}*/
