variable "alb_name" {
  description = "The name to use for this ALB"
  type        = string
}

variable "subnet_ids" {
  description = "The subnet IDs to deploy to"
  type        = list(string)
}

variable "tg_name" {
  default = ""
}

variable "target_group_arns" {
  default = ""
}
