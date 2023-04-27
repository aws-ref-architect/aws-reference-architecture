resource "aws_default_vpc" "default_vpc_to_destroy" {
//  cidr_block = "172.0.0.0/8"
  force_destroy = true
}
