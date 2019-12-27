provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
}

module "hello_world_app" {
  source = "../../../modules/services/hello-world-app"

  server_text = "${var.server_text}"

  environment = "${var.environment}"

  ami           = "ami-04763b3055de4860b"
  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 2
}
