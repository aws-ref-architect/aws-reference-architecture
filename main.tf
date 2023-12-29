// Global terraform state bucket.
module "s3_terraform_state" {
  source = "./modules/s3/terraform_state"
}

// Global terraform DynamoDB table.
module "dynamodb_terraform_state" {
  source = "./modules/dynamodb/terraform_state"
}
