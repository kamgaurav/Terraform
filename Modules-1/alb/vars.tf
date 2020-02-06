variable "web_alb_name" {}
variable "public_subnet_id" {
    type        = list(string)
  default     = []
}
variable "apps" {}
variable "web_target_group_arn" {}

variable "app_alb_name" {}
variable "private_subnet_id" {
    type        = list(string)
  default     = []
}
variable "app_target_group_arn" {}




