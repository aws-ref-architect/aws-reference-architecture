// Global terraform state bucket.
module "terraform_state" {
  source = "./modules/s3/terraform_state"
}

// Global logging bucket for all logs.
module "global_logs" {
  source = "./modules/s3/logs"
}

module "s3_website_production" {
  source      = "./modules/s3/website"
  bucket_name = "production.your-website.com"
  environment = "production"
}

module "s3_website_staging" {
  source      = "./modules/s3/website"
  bucket_name = "staging.your-website.com"
  environment = "staging"
}

module "s3_website_development" {
  source      = "./modules/s3/website"
  bucket_name = "development.your-website.com"
  environment = "development"
}

module "default_vpc_to_destroy" {
  source = "./modules/default_vpc"
}

module "production_vpc" {
  source             = "./modules/vpc"
  name               = "production"
  vpc_cidr           = var.production_vpc_cidr
  dmz_cidr           = var.production_dmz_subnets
  semi_private_cidr  = var.production_semi_private_subnets
  private_cidr       = var.production_private_subnets
  database_cidr      = var.production_database_subnets
  environment        = "production"
  availability_zones = var.availability_zones
}

module "production_vpn_wireguard" {
  source                  = "./modules/vpn"
  vpc_id                  = production_vpc.vpc.id
  vpc_name                = production_vpc.vpc.name
  vpn_wireguard_subnet_id = aws_subnet.vpn_0000001.id
}

locals {
  vpn_accessible_subnets = concat(
    aws_subnet.dmz_0000001.id,
    aws_subnet.dmz_0000002.id,
    aws_subnet.dmz_0000003.id,
    aws_subnet.semi_private_0000001.id,
    aws_subnet.semi_private_0000002.id,
    aws_subnet.semi_private_0000003.id,
    aws_subnet.private_0000001.id,
    aws_subnet.private_0000002.id,
    aws_subnet.private_0000003.id
  )
}

/*
module "production_postgresql" {
  source = "./modules/rds"
}
*/

module "staging_vpc" {
  source             = "./modules/vpc"
  name               = "staging"
  vpc_cidr           = var.staging_vpc_cidr
  dmz_cidr           = var.staging_dmz_subnets
  semi_private_cidr  = var.staging_semi_private_subnets
  private_cidr       = var.staging_private_subnets
  database_cidr      = var.staging_database_subnets
  environment        = "staging"
  availability_zones = var.availability_zones
}

module "development_vpc" {
  source             = "./modules/vpc"
  name               = "development"
  vpc_cidr           = var.development_vpc_cidr
  dmz_cidr           = var.development_dmz_subnets
  semi_private_cidr  = var.development_semi_private_subnets
  private_cidr       = var.development_private_subnets
  database_cidr      = var.development_database_subnets
  environment        = "development"
  availability_zones = var.availability_zones
}

// NOTE: localstack does not support ECR/ECS without a subscription.
// ECR repositories.
module "main_website" {
  source       = "./modules/ecs/ecr"
  service_name = "main-website-frontend"
}

module "development_dmz_cluster" {
  source      = "./modules/ecs"
  name        = "development_dmz"
  environment = "development"
  vpc_id      = development_vpc.id
  // base_image_id = ""
  availability_zones = var.availability_zones
  subnet_ids = [
    development_vpc.aws_subnet.dmz_0000001.id,
    development_vpc.aws_subnet.dmz_0000002.id,
    development_vpc.aws_subnet.dmz_0000003.id
  ]
  min_cluster_size            = 3
  max_cluster_size            = 12
  desired_cluster_size        = 3
  associate_public_ip_address = false
  root_volume_size            = 5
  docker_volume_size          = 5

  resource "aws_security_group" "dmz" {
    name        = "dmz"
    description = "Allow inbound HTTP(S) traffic."
    vpc_id      = development_vpc.id

    ingress {
      description = "HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      description = "HTTPS"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}