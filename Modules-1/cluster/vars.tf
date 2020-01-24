#Web variables
variable "web_config_name" {

}
variable "web_ami" {

}
variable "web_instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  type        = string
}
variable "web_user_data" {
  description = "The User Data script to run in each Instance at boot"
  type        = string
  default     = null
}
variable "public_cidr_block" {
  type        = list(string)
  default     = []
}
variable "public_subnet_id" {
  type        = list(string)
  default     = []
}


#App variables
variable "app_config_name" {

}
variable "app_ami" {

}
variable "app_instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  type        = string
}
variable "app_user_data" {
  description = "The User Data script to run in each Instance at boot"
  type        = string
  default     = null
}
variable "private_cidr_block" {
  type        = list(string)
  default     = []
}
variable "private_subnet_id" {
  type        = list(string)
  default     = []
}



variable "cluster_name" {
  description = "The name to use for all the cluster resources"
  type        = string
}
variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
  type        = number
}

variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG"
  type        = number
}
variable "target_group_arns" {
  description = "The ARNs of ELB target groups in which to register Instances"
  type        = list(string)
  default     = []
}

variable "health_check_type" {
  description = "The type of health check to perform. Must be one of: EC2, ELB."
  type        = string
  default     = "EC2"
}
variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

variable "vpc_id" {

}

