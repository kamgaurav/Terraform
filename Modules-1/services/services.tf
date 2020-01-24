provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
}
module "vpc" {
  source = "../vpc"

  vpc_cidr            = "10.0.0.0/16"
  env                 = "Stage"
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
  cluster_name        = "Staging-Cluster"
}

module "cluster" {
  source = "../cluster"

  vpc_id = module.vpc.vpc_id

  web_config_name   = "Web-Configuration"
  web_ami           = "ami-04763b3055de4860b"
  web_instance_type = "t2.micro"
  #web_user_data     = data.template_file.web_user_data.rendered
  #public_cidr_block = ["10.0.1.0/24"]
  public_cidr_block = [module.vpc.public_cidr_block]
  public_subnet_id = [module.vpc.public_subnet_id]

  app_config_name   = "App-Configuration"
  app_ami           = "ami-00d4e9ff62bc40e03"
  app_instance_type = "t2.micro"
  #app_user_data     = data.template_file.app_user_data.rendered

  private_cidr_block = ["10.0.2.0/24"]
  private_subnet_id = [module.vpc.private_subnet_id]

  cluster_name      = "Staging-Cluster"
  min_size          = 2
  max_size          = 2
  target_group_arns = [module.alb_tg.tg_arn]
  health_check_type = "ELB"

}

module "alb" {
  source = "../alb"

  web_alb_name         = "Web-Load-balancer"
  public_subnet_id     = module.vpc.public_subnet_id
  web_target_group_arn = module.alb_tg.tg_arn

  app_alb_name         = "App-Load-balancer"
  private_subnet_id    = module.vpc.private_subnet_id
  app_target_group_arn = module.alb_tg.tg_arn

  apps = ["web", "app"]

}

module "alb_tg" {
  source = "../alb_tg"

  tg_name     = "Hello-world"
  server_port = 8080
  vpc_id      = module.vpc.vpc_id

}

