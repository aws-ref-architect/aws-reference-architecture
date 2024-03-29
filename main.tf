// Global terraform state bucket.
module "s3_terraform_state" {
  source = "./modules/s3/terraform_state"
}

// Global terraform DynamoDB table.
module "dynamodb_terraform_state" {
  source = "./modules/dynamodb/terraform_state"
}

// Global logging bucket for all logs.
module "global_logs" {
  source = "./modules/s3/logs"
}
/*
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

/*
module "production_postgresql" {
  source = "./modules/rds"
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
*/