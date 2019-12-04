variable "server_port" {
  description = "The HTTP port number"
  default     = 8080
}

variable "cluster_name" {
  description = "THe name to use for all the cluster resources"
}

variable "db_remote_state_folder" {
  description = "The name of the folder for the database's remote state"
}

variable "instance_type" {
  description = "THe type of EC2 Instaces"
}

variable "min_size" {
  description = "The minimum number of EC2 instances in the ASG"
}

variable "max_size" {
  description = "The maximum number of EC2 instances in ASG"
}
