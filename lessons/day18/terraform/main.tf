# Simple backend-only image processor
# Upload image to source S3 → Lambda triggers → Processes → Saves to destination S3

# Random suffix for unique resource names
resource "random_id" "suffix" {
  byte_length = 4
}

# S3 bucket for uploading images - ORIGIN
resource "aws_s3_bucket" "upload_bucket" {
  bucket = local.upload_bucket_name

  tags = {
    Name        = "upload-bucket"
    Environment = var.env
  }
}

resource "aws_s3_bucket_versioning" "upload_bucket_versioning" {
  bucket = aws_s3_bucket.upload_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "upload_bucket_encryption" {
  bucket = aws_s3_bucket.upload_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "upload_bucket_public_access_block" {
  bucket = aws_s3_bucket.upload_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 bucket for processed images - DESTINATION
resource "aws_s3_bucket" "processed_bucket" {
  bucket = local.processed_bucket_name

  tags = {
    Name        = "processed-bucket"
    Environment = var.env
  }
}

resource "aws_s3_bucket_versioning" "processed_bucket_versioning" {
  bucket = aws_s3_bucket.processed_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "processed_bucket_encryption" {
  bucket = aws_s3_bucket.processed_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "processed_bucket_public_access_block" {
  bucket = aws_s3_bucket.processed_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# IAM role for Lambda function
resource "aws_iam_role" "lambda_role" {
  name = "${local.lambda_function_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "LambdaRolePolicy"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    name        = "lambda-role"
    Environment = var.env
  }
}

# IAM policy for Lambda
resource "aws_iam_role_policy" "lambda_policy" {
  name = "${local.lambda_function_name}-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:${var.region}:*:*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion"
        ]
        Resource = "${aws_s3_bucket.upload_bucket.arn}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl"
        ]
        Resource = "${aws_s3_bucket.processed_bucket.arn}/*"
      }
    ]
  })
}

# Lambda Layer
resource "aws_lambda_layer_version" "pillow_layer" {
  filename   = "${path.module}/pillow_layer.zip"
  layer_name = "${var.project_name}-pillow-layer"

  compatible_runtimes = [var.lambda_runtime]
  description         = "Pillow library for image processing"
}

# Data source for lambda processor
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../lambda/lambda_function.py"
  output_path = "${path.module}/lambda_function.zip"
}

# Lambda function
resource "aws_lambda_function" "image_processor" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = local.lambda_function_name
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = var.lambda_runtime
  timeout          = var.lambda_timeout
  memory_size      = var.lambda_memory_size

  layers = [aws_lambda_layer_version.pillow_layer.arn]

  environment {
    variables = {
      PROCESSED_BUCKET = aws_s3_bucket.processed_bucket.id
      LOG_LEVEL        = "INFO"
    }
  }
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "lambda_processor" {
  name              = "/aws/lambda/${local.lambda_function_name}"
  retention_in_days = var.cloudwatch_log_retention
}

# S3 Event Trigger
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.image_processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.upload_bucket.arn
}

# S3 bucket notification to trigger lambda on object creation
resource "aws_s3_bucket_notification" "upload_bucket_notification" {
  bucket = aws_s3_bucket.upload_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.image_processor.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}
