variable "bucket_name" {
  description = "Unique name of S3 bucket."
  type        = string
}

variable "tags" {
  description = "Tags."
  type        = map(string)
  default     = {}
}
