terraform {
  backend "s3" {
    bucket         = "tfstate-backend-s3"
    key            = "dev-tfstate/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
    access_key = ""
    secret_key = ""
  }
}

