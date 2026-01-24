variable "region" {
  default = "ap-south-1"
  type = string
}

variable "tags" {
  type = map(string)
  default = {
      Name = "dev-demo-ec2"
      Environment = "dev"
      CreatedBy = "Terraform"
  }
}
