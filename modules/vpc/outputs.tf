output "arn" {
  value = aws_vpc.vpc.arn
}

output "id" {
  value = aws_vpc.vpc.id
}

output "cidr" {
  value = aws_vpc.vpc.cidr_block
}

output "main_route_table_id" {
  value = aws_vpc.vpc.main_route_table_id
}

output "default_route_table_id" {
  value = aws_vpc.vpc.default_route_table_id
}

output "default_network_acl_id" {
  value = aws_vpc.vpc.default_network_acl_id
}

output "default_security_group_id" {
  value = aws_vpc.vpc.default_security_group_id
}

output "aws_subnet_dmz_0000001_id" {
  value = aws_subnet.dmz_0000001.id
}

output "aws_subnet_dmz_0000002_id" {
  value = aws_subnet.dmz_0000002.id
}

output "aws_subnet_dmz_0000003_id" {
  value = aws_subnet.dmz_0000003.id
}

output "tags" {
  value = aws_vpc.vpc.tags
}
