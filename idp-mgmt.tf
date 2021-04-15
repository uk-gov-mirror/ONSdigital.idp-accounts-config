provider "aws" {
  alias  = "idp-mgmt"
  region = "eu-west-2"

  assume_role {
    role_arn = "arn:aws:iam::${module.idp_mgmt.account_id}:role/OrganizationAccountAccessRole"
  }
}

module "idp_mgmt" {
  source  = "ONSdigital/account/aws"
  version = "~> 0.2.4"

  account_env        = "mgmt"
  account_team       = "cia"
  root_account_email = "aws.d.registration.003@ons.gov.uk"
  name               = "mgmt"
  dns_subdomain      = "mgmt"
  master_zone_id     = aws_route53_zone.org_zone.id
  iam_account_id     = module.iam.account_id

  providers = {
    aws         = aws.idp-mgmt
    aws.account = aws.account
  }
}

resource "aws_route53_record" "idp_mgmt" {
  zone_id = aws_route53_zone.org_zone.zone_id
  name    = module.idp_mgmt.zone_name
  type    = "NS"
  ttl     = "300"
  records = module.idp_mgmt.zone_name_servers
}
