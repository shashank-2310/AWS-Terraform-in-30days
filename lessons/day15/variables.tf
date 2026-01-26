variable "primary_region" {
  default = "ap-south-1"
  type = string
  description = "Primary AWS region"
}

variable "secondary_region" {
  default = "ap-south-2"
  type = string
  description = "Secondary AWS region"
}

variable "env" {
  default = "Dev"
  type = string
  description = "Environment tag for resources"
}

variable "primary_vpc_cidr" {
  default = "10.0.0.0/16"
  type = string
  description = "CIDR block for the primary VPC"
}

variable "secondary_vpc_cidr" {
  default = "10.1.0.0/16"
  type = string
  description = "CIDR block for the secondary VPC"
}

variable "primary_subnet_cidr" {
  default = "10.0.1.0/24"
  type = string
  description = "CIDR block for the primary subnet"
}

variable "secondary_subnet_cidr" {
  default = "10.1.1.0/24"
  type = string
  description = "CIDR block for the secondary subnet"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "primary_key_name" {
  description = "Name of the SSH key pair for Primary VPC instance (us-east-1)"
  type        = string
  default     = ""
}

variable "secondary_key_name" {
  description = "Name of the SSH key pair for Secondary VPC instance (us-west-2)"
  type        = string
  default     = ""
}
