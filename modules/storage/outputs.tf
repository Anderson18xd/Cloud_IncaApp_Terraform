output "bucket_arn" {
  value = aws_s3_bucket.s3_IncaApp.arn
}

output "bucket_name" {
  value = aws_s3_bucket.s3_IncaApp.id
}
