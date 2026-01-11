provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "task4_bucket" {
    bucket = "skdevops-terraform-task4-bucket"
    tags = {
        Name = "skdevops-terraform-task4-bucket"
        Environment = "Dev"
    }
}

resource "aws_s3_bucket_versioning" "task4_versioning" {
    bucket = aws_s3_bucket.task4_bucket.id
    versioning_configuration {
        status = "Enabled"
    }
}