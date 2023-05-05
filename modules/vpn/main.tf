locals {
  accessible_subnets = concat(var.dmz_cidr, var.semi_private_cidr, var.private_cidr)
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  # Canonical.
  owners = ["099720109477"]
}

// Wireguard VPN subnets.
resource "aws_subnet" "vpn_0000001" {
  vpc_id            = var.vpc.id
  cidr_block        = var.vpn_wireguard_cidr[0]
  availability_zone = var.availability_zones[0]
}

/* Unused VPN subnets.
resource "aws_subnet" "vpn_0000002" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.vpn_wireguard_cidr[1]
  availability_zone = var.availability_zones[1]
}

resource "aws_subnet" "vpn_0000003" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.vpn_wireguard_cidr[2]
  availability_zone = var.availability_zones[2]
}
*/

resource "aws_security_group" "wireguard" {
  name        = "${var.vpc_name}-vpn"
  description = "Wireguard VPN access."

  vpc_id = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = local.accessible_subnets
  }
}

resource "aws_instance" "wireguard" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.nano"
  subnet_id              = aws_subnet.vpn_0000001.id
  vpc_security_group_ids = [aws_security_group.wireguard.id]
}

resource "aws_eip" "wireguard" {
  vpc = true
}

resource "aws_eip_association" "wireguard" {
  instance_id   = aws_instance.wireguard.id
  allocation_id = aws_eip.wireguard.id
}
