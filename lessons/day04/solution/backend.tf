terraform {
    backend "s3" {
      bucket = "skdevops-terraform-state"
      key = "dev/terraform.tfstate"
      region = "ap-south-1"
      encrypt = true
    }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}