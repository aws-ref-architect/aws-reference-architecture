variable "main_vpc_cidr" {
  description = "IPv4 CIDR block for primary VPC."
  type = string
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones used by project."
  type = list
  default = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

variable "dmz_subnets" {
  description = "Web-facing subnets - DMZ."
  type = list
  default = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "semi_private_subnets" {
  description = "Semi-private app-tier subnets."
  type = list
  default = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
}

variable "private_subnets" {
  description = "Private app-tier subnets."
  type = list
  default = ["10.0.20.0/24", "10.0.21.0/24", "10.0.22.0/24"]
}

variable "database_subnets" {
  description = "Private database-tier subnets."
  type = list
  default = ["10.0.30.0/24", "10.0.31.0/24", "10.0.32.0/24"]
}
