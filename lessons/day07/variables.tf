variable "environment" {
    default = "dev"
    type = string
}

variable "region" {
    default = "ap-south-1"
    type = string
}

variable "monitoring_enabled" {
  description = "Enable detailed monitoring for EC2 instances"
  type = bool
  default = true
}

variable "associate_public_ip" {
  description = "Associate public IP address for EC2 instances"
  type = bool
  default = true
}

variable "cidr_block" {
  description = "CIDR block for VPC"
  type        = list(string)
  default     = ["10.0.0.0/8", "192.168.0.0/16" , "172.16.0.0/12"]
}

variable "allowed_vm_types" {
  description = "List of allowed VM types"
  type       = list(string)
  default    = ["t2.micro", "t2.small", "t3.micro", "t3.small"]
}

variable "allowed_region" {
  description = "Set of allowed regions"
  type        = set(string)
  default     = ["ap-south-1", "us-east-1", "us-west-2", "ap-south-1", "ap-south-2"]
}

variable "tags" {
  type = map(string)
  default = {
      Name = "dev-demo-ec2"
      Environment = "dev"
      CreatedBy = "Terraform"
  }
}

variable "ingress_values" {
  type = tuple([ number, string, number ])
  default = [ 443, "tcp", 443 ]
}

variable "config" {
  type = object({
    region = string,
    monitoring = bool,
    instance_count = number
  })
  default = {
    region = "ap-south-1",
    monitoring = true,
    instance_count = 1
  }
}