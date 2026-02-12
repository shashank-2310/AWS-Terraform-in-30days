locals {
  common_prefix = "skdevops"
  bucket_prefix = "${local.common_prefix}-${var.project_name}-${var.env}"
  upload_bucket_name = "${local.bucket_prefix}-upload-${random_id.suffix.hex}"
  processed_bucket_name = "${local.bucket_prefix}-processed-${random_id.suffix.hex}"
  lambda_function_name = "${local.common_prefix}-${var.project_name}-${var.env}-lambda"
}