terraform {
  backend "s3" {
    bucket = data.terraform_remote_state.ons_tfstate.ons_tfstate
    key    = "idp-accounts-config.tfstate"
    region = "eu-west-2"
  }
}

provider "aws" {
  region = var.region
}
