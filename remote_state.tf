
provider "aws" {
  version                 = "= 3.1.0"  
  region                  = var.region
  profile                 = "kateri"
  shared_credentials_file = "$HOME/.aws/credentials"
}

terraform {
  required_version = "= 0.12.29"

  backend "s3" {
    bucket         = "kateri-remote-state"
    key            = "PROD/platform.tfstate"
    region         = "us-west-1"
    profile        = "kateri"
    # dynamodb_table = "terraform-locking"
  }
  
}
