resource "aws_s3_bucket" "bucket1" {
  count = length(var.bucket_names)
  bucket = var.bucket_names[count.index]
  tags = var.tags
}

resource "aws_s3_bucket" "bucket2" {
  # bucket = var.bucket_names_set[count.index] => Error: The 'count' meta-argument is not compatible with 'set' type variables
  for_each = var.bucket_names_set
  bucket = each.value # Incase of set each.key = each.value, so either can be used
  tags = var.tags
  depends_on = [ aws_s3_bucket.bucket1 ]
}