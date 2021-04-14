provider "aws" {
  alias  = "idp-mgmt-dev"
  region = "eu-west-2"

  assume_role {
    role_arn = "arn:aws:iam::${module.idp_mgmt_dev.account_id}:role/OrganizationAccountAccessRole"
  }
}

module "idp_mgmt_dev" {
  source  = "ONSdigital/account/aws"
  version = "~> 0.2.3"

  account_env        = "dev"
  account_team       = "cia"
  root_account_email = "aws.d.registration.002@ons.gov.uk"
  name               = "mgmt-dev"
  dns_subdomain      = "mgmt-dev"
  master_zone_id     = aws_route53_zone.org_zone.id
  iam_account_id     = module.iam.account_id

  providers = {
    aws         = aws.idp-mgmt-dev
    aws.account = aws.account
  }
}

resource "aws_route53_record" "idp_mgmt_dev" {
  zone_id = aws_route53_zone.org_zone.zone_id
  name    = module.idp_mgmt_dev.zone_name
  type    = "NS"
  ttl     = "300"
  records = module.idp_mgmt_dev.zone_name_servers
}
