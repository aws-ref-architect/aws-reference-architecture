terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.31.0"
    }
  }

  backend "local" {
    path = ".terraform/terraform.tfstate"
  }

#  backend "s3" {
#    bucket = "terraform-state-backend"
#    key    = "terraform.state"
#    region = "us-east-2"
#    encrypt = true
#    dynamodb_table = "terraform_state_lock"
#  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}
