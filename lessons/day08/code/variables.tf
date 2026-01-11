variable "environment" {
    default = "dev"
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

variable "bucket_names" {
  description = "List of S3 bucket names to create"
  type = list(string)
  default = [ "skdevops-bucket-day08-1", "skdevops-bucket-day08-2" ]
}

variable "bucket_names_set" {
  description = "List of S3 bucket names to create"
  type = set(string)
  default = [ "skdevops-bucket-day08-11", "skdevops-bucket-day08-22" ]
}