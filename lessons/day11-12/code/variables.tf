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

variable "instance_type" {
  default = "t2.micro"
  validation {
    condition = length(var.instance_type) >= 2 && length(var.instance_type) <= 20
    error_message = "Instance type must be between 2 and 20 characters long"
  }
  validation {
    condition = can(regex("^t[2-3]\\.", var.instance_type))
    error_message = "Instance type must start with t2 or t3"
  }
}

variable "backup_name" {
  default = "daily_backup"
  validation {
    condition = endswith(var.backup_name, "_backup")
    error_message = "Backup name must end with '_backup'"
  }
}

variable "creds" {
  default = "xyz12345"
  # sensitive = true
}

variable "user_location" {
  default = ["us-east-1", "us-west-2", "us-west-1"]
}

variable "default_location" {
  default = ["us-west-1"]
}

variable "monthly_cost" {
  default = [-50, 100, 75, 200] # -50 is a credit
}