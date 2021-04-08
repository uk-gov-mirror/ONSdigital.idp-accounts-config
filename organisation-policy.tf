resource "aws_organizations_policy" "deny_leaving_org" {
  name    = "deny-leaving-org"
  content = data.aws_iam_policy_document.deny_leaving_org.json
}

resource "aws_organizations_policy_attachment" "deny_leaving_org" {
  policy_id = aws_organizations_policy.deny_leaving_org.id
  target_id = aws_organizations_organization.aws_d.master_account_id
}

resource "aws_organizations_policy" "deny_deletion_specific_resources" {
  name    = "deny-deletion-specific-resources"
  content = data.aws_iam_policy_document.deny_deletion_specific_resources.json
}

resource "aws_organizations_policy_attachment" "deny_deletion_specific_resources" {
  policy_id = aws_organizations_policy.deny_deletion_specific_resources.id
  target_id = aws_organizations_organization.aws_d.master_account_id
}

resource "aws_organizations_policy" "require_s3_encryption" {
  name    = "require-s3-encryption"
  content = data.aws_iam_policy_document.require_s3_encryption.json
}

resource "aws_organizations_policy_attachment" "require_s3_encryption" {
  policy_id = aws_organizations_policy.require_s3_encryption.id
  target_id = aws_organizations_organization.aws_d.master_account_id
}

resource "aws_organizations_policy" "restrict_regions" {
  name    = "restrict-regions"
  content = data.aws_iam_policy_document.restrict_regions.json
}

resource "aws_organizations_policy_attachment" "restrict_regions" {
  policy_id = aws_organizations_policy.restrict_regions.id
  target_id = aws_organizations_organization.aws_d.master_account_id
}
