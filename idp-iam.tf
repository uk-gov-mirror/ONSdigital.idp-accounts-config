provider "aws" {
  alias  = "iam"
  region = "eu-west-2"

  assume_role {
    role_arn = "arn:aws:iam::${module.iam.account_id}:role/OrganizationAccountAccessRole"
  }
}

module "iam" {
  source  = "ONSdigital/account/aws"
  version = "~> 0.2.3"

  account_env        = "iam"
  account_team       = "cia"
  root_account_email = "aws.d.registration.001@ons.gov.uk"
  name               = "iam"
  dns_subdomain      = "iam"
  master_zone_id     = aws_route53_zone.org_zone.id
  iam_account_id     = module.iam.account_id

  providers = {
    aws         = aws.iam
    aws.account = aws.account
  }
}
