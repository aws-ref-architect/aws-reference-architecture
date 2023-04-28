module "s3_website_staging" {
  source      = "./modules/s3/website"
  bucket_name = "staging"
}

module "default_vpc_to_destroy" {
  source = "./modules/default_vpc"
}

module "main_vpc" {
  source   = "./modules/vpc"
  vpc_cidr = var.main_vpc_cidr
}
