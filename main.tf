module "s3_website_staging" {
  source      = "./modules/s3/website"
  bucket_name = "staging"
}

module "default_vpc_to_destroy" {
  source = "./modules/default_vpc"
}

module "production_vpc" {
  source   = "./modules/vpc"
  name = "production"
  vpc_cidr = var.production_vpc_cidr
  dmz_cidr = var.production_dmz_subnets
  semi_private_cidr = var.production_semi_private_subnets
  private_cidr = var.production_private_subnets
  database_cidr = var.production_database_subnets
  environment = "production"
  availability_zones = var.availability_zones
}

module "staging_vpc" {
  source   = "./modules/vpc"
  name = "staging"
  vpc_cidr = var.staging_vpc_cidr
  dmz_cidr = var.staging_dmz_subnets
  semi_private_cidr = var.staging_semi_private_subnets
  private_cidr = var.staging_private_subnets
  database_cidr = var.staging_database_subnets
  environment = "staging"
  availability_zones = var.availability_zones
}

module "development_vpc" {
  source   = "./modules/vpc"
  name = "development"
  vpc_cidr = var.development_vpc_cidr
  dmz_cidr = var.development_dmz_subnets
  semi_private_cidr = var.development_semi_private_subnets
  private_cidr = var.development_private_subnets
  database_cidr = var.development_database_subnets
  environment = "development"
  availability_zones = var.availability_zones
}
