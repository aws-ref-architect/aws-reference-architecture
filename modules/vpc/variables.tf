variable "vpc_cidr" {
  description = "IPv4 CIDR block for VPC."
  type        = string
}

variable "tags" {
  description = "Tags."
  type        = map(string)
  default     = {}
}
