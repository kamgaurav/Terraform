output "vpc_id" {
  description = "Get Me VPC ID"
  value       = ["${aws_vpc.default.id}"]
}
