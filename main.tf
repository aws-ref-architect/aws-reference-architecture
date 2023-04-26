module "s3_website_staging" {
  source = "./modules/s3/website"
  bucket_name = "staging"
}
