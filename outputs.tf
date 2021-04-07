output "org_root_account_id" {
  value       = aws_organizations_organization.aws_d.master_account_id
  description = "The AWS account Id of the organisation root account"
}

output "org_root_account_arn" {
  value       = aws_organizations_organization.aws_d.master_account_arn
  description = "The AWS account arn of the organisation root account"
}

output "org_root_account_email" {
  value       = aws_organizations_organization.aws_d.master_account_email
  description = "The AWS account email of the organisation root account"
}

output "org_member_account_ids" {
  value       = aws_organizations_organization.aws_d.non_master_accounts
  description = "A list of organisation member accounts"
}

output "org_zone_id" {
  value       = aws_route53_zone.org_zone.id
  description = "The Id of the organisation route53 zone"
}

output "org_zone_name" {
  value       = aws_route53_zone.org_zone.name
  description = "The name of the organisation route53 zone"
}

output "org_zone_name_servers" {
  value       = aws_route53_zone.org_zone.name_servers
  description = "The name server records from the organisation route53 zone"
}
