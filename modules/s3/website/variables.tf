variable "bucket_name" {
  description = "Unique name of S3 bucket."
  type        = string
}

variable "environment" {
  description = "Specify one of: production, staging, development, or development_0000001-development_1000000"
  type = string
}

variable "tags" {
  description = "Tags."
  type        = map(string)
  default     = {}
}
