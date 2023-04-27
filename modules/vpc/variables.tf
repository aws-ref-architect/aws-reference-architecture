variable "vpc_cidr" {
  description = "Network of valid host IPs."
  type        = string
}

variable "tags" {
  description = "Tags."
  type        = map(string)
  default     = {}
}
