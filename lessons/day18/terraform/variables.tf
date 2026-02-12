variable "region" {
  default     = "ap-south-1"
  type        = string
  description = "AWS region to deploy resources"
}

variable "project_name" {
  default     = "image-processor"
  type        = string
  description = "Project name to be used as prefix for resources"
}

variable "env" {
  default     = "dev"
  type        = string
  description = "Environment name to be used as suffix for resources"
}

variable "cloudwatch_log_retention" {
  default = 7
  type = number
  description = "Number of days to retain CloudWatch logs"
}

variable "lambda_runtime" {
  default     = "python3.12"
  type        = string
  description = "Runtime for the Lambda function"
}

variable "lambda_timeout" {
  default     = 60
  type        = number
  description = "Lambda function timeout in seconds"
}

variable "lambda_memory_size" {
  default     = 1024
  type        = number
  description = "Lambda function memory size in MB"
}
