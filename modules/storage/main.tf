resource "aws_s3_bucket" "s3_IncaApp" {
  bucket = var.bucket_name
  tags   = merge(var.common_tags, { Name = var.bucket_name })
  lifecycle {

    prevent_destroy = false
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.s3_IncaApp.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
