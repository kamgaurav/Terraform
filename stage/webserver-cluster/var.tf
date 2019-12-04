variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "region" {}

variable "server_port" {
  description = "The HTTP port number"
  default     = 8080
}