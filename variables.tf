// Company S3 bucket prefix for uniqueness.
variable "company_s3_bucket_prefix" {
  description = "Company prefix for S3 bucket uniqueness."
  type = string
  default = "reference-architecture"
}

// All environments.
variable "availability_zones" {
  description = "Availability zones used by project."
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

// Production environment.
variable "production_vpc_cidr" {
  description = "IPv4 CIDR block for production VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "production_dmz_subnets" {
  description = "Web-facing subnets - DMZ."
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "production_semi_private_subnets" {
  description = "Semi-private app-tier subnets."
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
}

variable "production_private_subnets" {
  description = "Private app-tier subnets."
  type        = list(string)
  default     = ["10.0.20.0/24", "10.0.21.0/24", "10.0.22.0/24"]
}

variable "production_database_subnets" {
  description = "Private database-tier subnets."
  type        = list(string)
  default     = ["10.0.30.0/24", "10.0.31.0/24", "10.0.32.0/24"]
}

// Staging environment.
variable "staging_vpc_cidr" {
  description = "IPv4 CIDR block for primary VPC."
  type        = string
  default     = "10.10.0.0/16"
}

variable "staging_dmz_subnets" {
  description = "Web-facing subnets - DMZ."
  type        = list(string)
  default     = ["10.10.0.0/24", "10.10.1.0/24", "10.10.2.0/24"]
}

variable "staging_semi_private_subnets" {
  description = "Semi-private app-tier subnets."
  type        = list(string)
  default     = ["10.10.10.0/24", "10.10.11.0/24", "10.10.12.0/24"]
}

variable "staging_private_subnets" {
  description = "Private app-tier subnets."
  type        = list(string)
  default     = ["10.10.20.0/24", "10.10.21.0/24", "10.10.22.0/24"]
}

variable "staging_database_subnets" {
  description = "Private database-tier subnets."
  type        = list(string)
  default     = ["10.10.30.0/24", "10.10.31.0/24", "10.10.32.0/24"]
}

// Development environments.
variable "development_vpc_cidr" {
  description = "IPv4 CIDR block for primary VPC."
  type        = string
  default     = "10.20.0.0/16"
}

variable "development_dmz_subnets" {
  description = "Web-facing subnets - DMZ."
  type        = list(string)
  default     = ["10.20.0.0/24", "10.20.1.0/24", "10.20.2.0/24"]
}

variable "development_semi_private_subnets" {
  description = "Semi-private app-tier subnets."
  type        = list(string)
  default     = ["10.20.10.0/24", "10.20.11.0/24", "10.20.12.0/24"]
}

variable "development_private_subnets" {
  description = "Private app-tier subnets."
  type        = list(string)
  default     = ["10.20.20.0/24", "10.20.21.0/24", "10.20.22.0/24"]
}

variable "development_database_subnets" {
  description = "Private database-tier subnets."
  type        = list(string)
  default     = ["10.20.30.0/24", "10.20.31.0/24", "10.20.32.0/24"]
}
