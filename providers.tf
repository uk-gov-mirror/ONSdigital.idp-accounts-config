provider "aws" {
  region = "eu-west-2"
}

provider "aws" {
  alias  = "account"
  region = "eu-west-2"
}
