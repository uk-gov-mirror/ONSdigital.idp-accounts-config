data "terraform_remote_state" "ons_tfstate" {
  backend = "s3"

  config = {
    bucket = "ons-tfstate"
    region = "eu-west-2"
    key    = "default"
  }
}
