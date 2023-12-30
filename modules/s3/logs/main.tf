resource "aws_s3_bucket" "global-logs" {
  bucket = "${var.company_s3_bucket_prefix}-global-logs"
}

resource "aws_s3_bucket_ownership_controls" "oc-global-logs" {
  bucket = aws_s3_bucket.global-logs.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "oc-global-logs" {
  bucket = aws_s3_bucket.global-logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "global-logs-acl"  {
  depends_on = [
    aws_s3_bucket_ownership_controls.oc-global-logs,
    aws_s3_bucket_public_access_block.oc-global-logs,
  ]

  bucket = aws_s3_bucket.global-logs.id
  acl    = "private"
}

resource "aws_s3_bucket" "logs-bucket" {
  bucket = "${var.company_s3_bucket_prefix}-logs-bucket"
}

resource "aws_s3_bucket_ownership_controls" "oc-logs-bucket" {
  bucket = aws_s3_bucket.logs-bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "oc-logs-bucket" {
  bucket = aws_s3_bucket.logs-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "logs-bucket-acl"  {
  depends_on = [
    aws_s3_bucket_ownership_controls.oc-logs-bucket,
    aws_s3_bucket_public_access_block.oc-logs-bucket,
  ]

  bucket = aws_s3_bucket.logs-bucket.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_logging" "logging" {
  bucket = aws_s3_bucket.global-logs.id

  target_bucket = aws_s3_bucket.logs-bucket.id
  target_prefix = "log/"
}
