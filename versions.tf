provider "aws" {
  region = "eu-west-2"
}

provider "aws" {
  alias  = "account"
  region = "eu-west-2"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.35.0, < 4.0.0"
    }
  }
  required_version = ">= 0.12.0, < 0.15.0"

  backend "s3" {
    acl        = "private"
    bucket     = "aws-d-org-tfstate"
    encrypt    = true
    key        = "aws-d-org.tfstate"
    kms_key_id = "arn:aws:kms:eu-west-2:974325445151:key/9928b5d5-ed0b-423b-a347-b42b4b009391"
    region     = "eu-west-2"
  }
}
