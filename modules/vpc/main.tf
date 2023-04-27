resource "aws_vpc" "vpc" {
  cidr_block       = "${var.vpc_cidr}"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_network_address_usage_metrics = true
  enable_dns_hostnames = true
}

// VPC Subnets.

resource "aws_subnet" "dmz_0000001" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-2a"
}

resource "aws_subnet" "dmz_0000002" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2b"
}

resource "aws_subnet" "dmz_0000003" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-2c"
}

resource "aws_subnet" "semi_private_0000001" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.10.0/24"
  availability_zone = "us-east-2a"
}

resource "aws_subnet" "semi_private_0000002" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.11.0/24"
  availability_zone = "us-east-2b"
}

resource "aws_subnet" "semi_private_0000003" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.12.0/24"
  availability_zone = "us-east-2c"
}

resource "aws_subnet" "private_0000001" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.20.0/24"
  availability_zone = "us-east-2a"
}

resource "aws_subnet" "private_0000002" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.21.0/24"
  availability_zone = "us-east-2b"
}

resource "aws_subnet" "private_0000003" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.22.0/24"
  availability_zone = "us-east-2c"
}

resource "aws_subnet" "database_0000001" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.30.0/24"
  availability_zone = "us-east-2a"
}

resource "aws_subnet" "database_0000002" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.31.0/24"
  availability_zone = "us-east-2b"
}

resource "aws_subnet" "database_0000003" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.32.0/24"
  availability_zone = "us-east-2c"
}
