module "s3_website_staging" {
  source = "./modules/s3/website"
  bucket_name = "staging"
}

module "vpc_main_staging" {
  source = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
}
