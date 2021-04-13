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

resource "aws_acm_certificate" "org_cert" {
  domain_name       = aws_route53_zone.org_zone.name
  validation_method = "DNS"

  subject_alternative_names = [
    module.idp_mgmt.zone_name,
    module.idp_mgmt_dev.zone_name
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "org_cert_validation_sans" {
  for_each = {
    for domain_validation in aws_acm_certificate.org_cert.domain_validation_options : domain_validation.domain_name => {
      name    = domain_validation.resource_record_name
      records = domain_validation.resource_record_value
      type    = domain_validation.resource_record_type
    }
  }

  name    = each.value.name
  type    = each.value.type
  zone_id = aws_route53_zone.org_zone.zone_id
  ttl     = 60

  records = [each.value.records]
}

resource "aws_acm_certificate_validation" "org_cert_validation" {
  certificate_arn = aws_acm_certificate.org_cert.arn

  validation_record_fqdns = [
    for validation_record in aws_route53_record.org_cert_validation_sans : validation_record.fqdn
  ]
}
