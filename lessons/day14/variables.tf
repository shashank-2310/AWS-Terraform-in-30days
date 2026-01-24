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

variable "bucket_name" {
  default = "skdevops-101"
}
