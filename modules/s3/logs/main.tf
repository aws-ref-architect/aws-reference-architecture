resource "aws_s3_bucket" "global_logs" {
  bucket = "global-logs"
}

resource "aws_s3_bucket_acl" "global_logs" {
  bucket = aws_s3_bucket.global_logs.id
  acl    = "private"
}

resource "aws_s3_bucket" "logs_bucket" {
  bucket = "logs-bucket"
}

resource "aws_s3_bucket_acl" "logs_bucket_acl" {
  bucket = aws_s3_bucket.logs_bucket.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_logging" "logging" {
  bucket = aws_s3_bucket.global_logs.id

  target_bucket = aws_s3_bucket.logs_bucket.id
  target_prefix = "log/"
}
