output "s3_bucket_arn" {
  value = module.s3_website_staging.arn
}

output "s3_bucket_name" {
  description = "Name (id) of the bucket"
  value       = module.s3_website_staging.name
}

output "s3_bucket_domain" {
  description = "Domain name of the bucket"
  value       = module.s3_website_staging.domain
}

output "s3_bucket_website_endpoint" {
  value = module.s3_website_staging.website_endpoint
}
