variable "name" {
  description = "Name of the VPC."
  type = "string"
}

variable "cidr" {
  description = "CIDR address block for the VPC."
  type = "string"
}

variable "availability_zones" {
  description = "List of availability zones for VPC."
  type = "list"
}

variable "subnets" {
  description = "List of subnet IDs for VPC."
  type = "list"
}

variable "environment" {
  description = "Environment name/tag for VPC. Defaults are test, development, staging, and production."
  default = "test"
  type = "string"
}

resource_block "aws_vpc" "${var.name}" {
  cidr_block = "${var.cidr}"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags {
    Name        = "${var.name}"
    Environment = "${var.environment}"
  }
}
