variable "vpc_name" {
  description = "Name of VPC."
  type        = string
}

variable "vpc_id" {
  description = "ID of VPC."
  type        = string
}

variable "vpn_wireguard_subnet_id" {
  description = "ID of subnet for Wireguard VPN."
  type        = string
}

variable "vpn_wireguard_cidr" {
  description = "IPv4 CIDR blocks for wireguard VPN tier of VPC."
  type        = list(string)
  default     = ["10.1.0.0/24", "10.1.1.0/24", "10.1.2.0/24"]
}

variable "dmz_cidr" {
  description = "IPv4 CIDR blocks for DMZ tier of VPC."
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "semi_private_cidr" {
  description = "IPv4 CIDR blocks for semi-private tier of VPC."
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
}

variable "private_cidr" {
  description = "IPv4 CIDR blocks for private tier of VPC."
  type        = list(string)
  default     = ["10.0.20.0/24", "10.0.21.0/24", "10.0.22.0/24"]
}

variable "accessible_subnets" {
  description = "Exhaustive list of accessible subnets."
  type        = list(string)
}

variable "wg_server_port" {
  type = number
  default = 51820
}

variable "wg_server_private_key" {
  default = ""
}

variable "wg_server_public_key" {
  default = ""
}

variable "wg_peers" {
  type = list
  default = [{
    name = "dummy"
    public_key = ""
    allowed_ips = "10.0.0.0/24"
  }]
}