locals {
    bucket_name = "skdevops-tf-bucket-${var.environment}"
    vpc_name = "${var.environment}-vpc"
}