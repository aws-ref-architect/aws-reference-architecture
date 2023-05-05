# Based on: https://www.perdian.de/blog/2021/12/27/setting-up-a-wireguard-vpn-at-aws-using-terraform/

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
  user_data = data.template_file.wireguard_userdata.rendered
}

resource "aws_eip" "wireguard" {
  vpc = true
}

resource "aws_eip_association" "wireguard" {
  instance_id   = aws_instance.wireguard.id
  allocation_id = aws_eip.wireguard.id
}

data "template_file" "wireguard_userdata_peers" {
  template = file("resources/wireguard-user-data-peers.tpl")
  count = length(var.wg_peers)
  vars = {
    peer_name = var.wg_peers[count.index].name
    peer_public_key = var.wg_peers[count.index].public_key
    peer_allowed_ips = var.wg_peers[count.index].allowed_ips
  }
}

data "template_file" "wireguard_userdata" {
  template = file("resources/wireguard-user-data.tpl")
  vars = {
    client_network_cidr = var.vpn_wireguard_cidr[0]
    wg_server_private_key = var.wg_server_private_key
    wg_server_public_key = var.wg_server_public_key
    wg_server_port = var.wg_server_port
    wg_peers = join("\n", data.template_file.wireguard_userdata_peers.*.rendered)
  }
}
