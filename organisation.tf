resource "aws_organizations_organization" "aws_d" {
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "guardduty.amazonaws.com",
    "ram.amazonaws.com",
    "securityhub.amazonaws.com"
  ]

  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY"
  ]

  feature_set = "ALL"
}

resource "aws_route53_zone" "org_zone" {
  name = "idp.onsdigital.uk"
}

resource "aws_guardduty_detector" "aws_d" {
  enable = true
}

resource "aws_guardduty_organization_admin_account" "aws_d" {
  depends_on = [aws_organizations_organization.aws_d]

  admin_account_id = aws_organizations_organization.aws_d.master_account_id
}

resource "aws_guardduty_organization_configuration" "aws_d" {
  auto_enable = true
  detector_id = aws_guardduty_detector.aws_d.id
}

resource "aws_securityhub_account" "aws_d" {}

resource "aws_securityhub_organization_admin_account" "aws_d" {
  depends_on = [aws_organizations_organization.aws_d]

  admin_account_id = aws_organizations_organization.aws_d.master_account_id
}
