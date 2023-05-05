// All environments.
variable "availability_zones" {
  description = "Availability zones used by project."
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

variable "environment" {
  description = "Specify one of: production, staging, development, or development_0000001-development_1000000"
  type        = string
}

variable "min_allocated_storage" {
  description = "Minimum storage allocation in GBs."
  type        = number
  default     = 10
}

variable "max_allocated_storage" {
  description = "Minimum storage allocation in GBs."
  type        = number
  default     = 100
}

variable "postgresql_database_name" {
  type    = string
  default = "postgres"
}

variable "postgresql_engine_version" {
  type    = string
  default = 15.2
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "private_cidr" {
  type    = list(string)
  default = ["10.0.20.0/24", "10.0.21.0/24", "10.0.22.0/24"]
}
