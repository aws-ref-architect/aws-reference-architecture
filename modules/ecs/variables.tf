variable "cluster_name" {
  description = "Name of ECS cluster."
}

variable "environment" {
  description = "Specify one of: production, staging, development, or development_0000001-development_1000000"
  type = string
}

variable "vpc_id" {
  description = "ID of VPC."
  type = string
}

variable "base_image_id" {
  description = "AMI image identifier."
  type = string
  default = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

variable "subnet_ids" {
  description = "List of subnet IDs."
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security groups for cluster."
  type = list(string)
}

variable "region" {
  description = "AWS region."
  type = string
  default = "us-east-2"
}

variable "availability_zones" {
  description = "Availability zones used by cluster."
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

variable "instance_type" {
  description = "EC2 instance type used by cluster."
  type = string
  default = "t3.nano"
}

variable "min_cluster_size" {
  description = "Minimum instance count."
  default     = 3
}

variable "max_cluster_size" {
  description = "Maximum instance count."
  type = number
  default     = 12
}

variable "desired_cluster_size" {
  description = "Desired instance count."
  type = number
  default     = 3
}

variable "associate_public_ip_address" {
  description = "Assign public IP addresses to instances."
  type = bool
  default = false
}

variable "root_volume_size" {
  description = "Root volume size in GB."
  default     = 5
}

variable "docker_volume_size" {
  description = "Attached EBS volume size in GB."
  default     = 5
}
