variable "vpc_cidr" {}

variable "env" {}

variable "public_subnet_cidr" {
    type        = list(string)
    default     = []
}

variable "private_subnet_cidr" {
    type        = list(string)
    default     = []
}

variable "cluster_name" {}
