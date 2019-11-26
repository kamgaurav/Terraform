# Create basic S3 bucket (versioning enabled) with Terraform

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.aws_region}"
}

resource "aws_s3_bucket" "tfstate-backend-s3" {
  bucket = "tfstate-backend-s3"
  acl    = "private"

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_object" "bucket-folder" {
  bucket = "${aws_s3_bucket.tfstate-backend-s3.id}"
  key    = "dev-state/"
}

resource "aws_dynamodb_table" "tfstate-lock-table" {
  name           = "terraform-lock"
  hash_key       = "LockID"
  billing_mode   = "PROVISIONED"
  write_capacity = 5
  read_capacity  = 5

  attribute {
    name = "LockID"
    type = "S"
  }
}