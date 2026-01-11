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

# Create a VPC
resource "aws_vpc" "task2_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "vpc-for-s3"
  }
}

# Create a S3 Bucket
resource "aws_s3_bucket" "task2_bucket" {
  bucket = "skdevops-terraform-task2-bucket" # Change to a unique name
#   depends_on = [ aws_vpc.task2_vpc ] # Explicit dependency on VPC

  tags = {
    Name        = "task2-bucket"
    Environment = "Dev"
  }
}

# Create a VPC Endpoint for S3
resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id       = aws_vpc.task2_vpc.id # Creates implicit dependency on VPC
  service_name = "com.amazonaws.ap-south-1.s3"
}