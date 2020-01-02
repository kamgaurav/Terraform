
variable "alb_name" {
  description = "The name to use for this ALB"
  type        = string
}

variable "subnet_ids" {
  description = "The subnet IDs to deploy to"
  type        = list(string)
}

variable "target_group_arn" {
  description = "The target_group_arn to deploy to"
  #type        = list(string)
}
