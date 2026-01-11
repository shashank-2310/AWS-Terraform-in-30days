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