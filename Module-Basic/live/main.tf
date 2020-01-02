provider "aws" {
  region = "us-east-1"
  access_key = ""
  secret_key = ""
}

module "hello_world_app" {

  source = "../services"

  server_text = var.server_text

  environment            = var.environment
  
  instance_type      = "t2.micro"
  min_size           = 2
  max_size           = 2
}
