resource "aws_s3_bucket" "s3-terraform-state" {
  bucket = "${var.company_s3_bucket_prefix}-terraform-state"
  object_lock_enabled = true
  tags = {
    "Environment": "global"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.s3-terraform-state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_encryption" {
  bucket = aws_s3_bucket.s3-terraform-state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_s3_bucket_object_lock_configuration" "terraform_state_object_lock" {
  bucket = aws_s3_bucket.s3-terraform-state.id
}
