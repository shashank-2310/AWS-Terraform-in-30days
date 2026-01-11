locals {
    bucket_name = "${var.channel_name}-bucket-${var.environment}"
    vpc_name = "${var.environment}-vpc"
}