// Company S3 bucket prefix for uniqueness.
variable "company_s3_bucket_prefix" {
  description = "Company prefix for S3 bucket uniqueness."
  type = string
  default = "reference-architecture"
}
