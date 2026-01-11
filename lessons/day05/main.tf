terraform {
  # Configure the S3 Remote Backend
  backend "s3" {
    bucket = "skdevops-terraform-state" # Change to your unique bucket name
    key    = "dev/terraform.tfstate"
    region = "ap-south-1"
    encrypt = true
    use_lockfile = true
  }
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

# Define a variable and access it wherever needed
variable "environment" {
    default = "dev"
    type = string
}

variable "channel_name" {
    default = "skdevops-tf"
    type = string
}

variable "region" {
    default = "ap-south-1"
    type = string
}

locals {
    bucket_name = "${var.channel_name}-bucket-${var.environment}"
    vpc_name = "${var.environment}-vpc"
}

# Create a VPC
resource "aws_vpc" "demo_vpc" {
  cidr_block = "10.0.0.0/16"
  region = var.region
    tags = {
        Name = local.vpc_name
        Environment = var.environment
    }
}

# Create a S3 Bucket
resource "aws_s3_bucket" "demo_bucket" {
  bucket = local.bucket_name
  region = var.region
  tags = {
    Name        = local.bucket_name
    Environment = var.environment
  }
}

# Create a EC2 Instance
resource "aws_instance" "demo_ec2" {
    ami           = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
    instance_type = "t2.micro"
    region = var.region  
    tags = {
        Name = "${var.environment}demo-ec2"
        Environment = var.environment
    }
}

# Output variables for printing after apply and passing to other configurations
output "vpc_id" {
    value = aws_vpc.demo_vpc.id
}

output "ec2_id" {
    value = aws_instance.demo_ec2.id
}