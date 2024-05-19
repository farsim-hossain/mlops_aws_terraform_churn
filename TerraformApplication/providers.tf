terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = ".aws/creds/creds"
  profile                 = "default"
}


terraform {
  backend "s3" {
    bucket = "terraform-backends-churn"
    key    = "churn-application/backend/terraform.tfstate"
    region = "us-east-1"
    shared_credentials_file = ".aws/creds/creds"
  }
}