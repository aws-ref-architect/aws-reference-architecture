/*
resource "aws_default_vpc" "default_vpc_to_destroy" {
  cidr_block = "172.0.0.0/8"
  force_destroy = true
}

resource "aws_default_subnet" "default_subnet_to_destroy" {
  force_destroy = true
  availability_zone = "us-east-2a"
}
*/
