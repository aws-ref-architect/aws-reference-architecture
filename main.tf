module "s3_website_staging" {
  source = "./modules/s3/website"
  bucket_name = "staging"
}
/*
module "default_vpc" {
  source = "./modules/default_vpc"
  vpc_cidr = "${var.default_vpc_cidr}"
}
*/
module "main_vpc" {
  source = "./modules/vpc"
  vpc_cidr = "${var.default_vpc_cidr}"
}
