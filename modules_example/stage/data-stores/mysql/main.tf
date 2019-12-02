provider "aws" {
  region     = "${var.region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

resource "aws_db_instance" "db_instance" {
  engine            = "mysql"
  allocated_storage = 10
  instance_class    = "db.t2.micro"
  name              = "demodbinstance"
  username          = "admin"
  password          = "${var.db_password}"
  /*need to add below to delete rds, otherwise "Error: DB Instance FinalSnapshotIdentifier
  is required when a final snapshot is required"*/
  skip_final_snapshot = true
}
