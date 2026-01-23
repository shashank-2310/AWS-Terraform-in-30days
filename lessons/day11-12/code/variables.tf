variable "region" {
  default     = "ap-south-1"
  description = "The AWS region to deploy resources in"
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "Project ALPHA Resource"
}

variable "default_tags" {
  default = {
    company    = "SK-DevOps"
    managed_by = "Terraform"
  }
}

variable "environment_tags" {
  default = {
    environment = "production"
    cost_center = "cc-123"
  }
}

variable "bucket_name" {
  default = "ProjectALPHAStorageBucket with CAPS and spaces!!!"
}

variable "allowed_ports" {
  default = "80,443,8080,3306"
}

variable "environment" {
  default = "prod"
}

variable "instance_size" {
  default = {
    dev     = "t3.small"
    staging = "t3.medium"
    prod    = "t3.large"
  }
}
