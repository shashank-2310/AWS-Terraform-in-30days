terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
}

# Create a S3 Bucket
resource "aws_s3_bucket" "demo_bucket" {
  bucket = "terraform-demo-bucket-sk-12345" # Change to a unique name

  tags = {
    # Name        = "My bucket" # Change and tf apply again to see update in tags
    Name        = "My bucket 2.0"
    Environment = "Dev"
  }
}