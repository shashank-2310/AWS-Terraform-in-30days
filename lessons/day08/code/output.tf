output "bucket_ids1" {
    value = [for b in aws_s3_bucket.bucket1 : b.id]
}

output "bucket_names1" {
    value = [for b in aws_s3_bucket.bucket1 : b.bucket]
}

output "bucket_ids2" {
    value = [for b in aws_s3_bucket.bucket2 : b.id]
}

output "bucket_names2" {
    value = [for b in aws_s3_bucket.bucket2 : b.bucket]
}