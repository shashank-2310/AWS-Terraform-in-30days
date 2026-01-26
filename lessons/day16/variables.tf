variable "region" {
  default     = "ap-south-1"
  type        = string
  description = "AWS region"
}

variable "env" {
  default     = "Dev"
  type        = string
  description = "Environment tag for resources"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}
