variable "environment" {
    default = "dev"
    type = string
}

variable "region" {
  default = "ap-south-1"
  type = string
}

variable "allowed_vm_types" {
  description = "List of allowed VM types"
  type       = list(string)
  default    = ["t2.micro", "t2.small", "t3.micro", "t3.small"]
}

variable "tags" {
  type = map(string)
  default = {
      Name = "dev-demo-ec2"
      Environment = "dev"
      CreatedBy = "Terraform"
  }
}