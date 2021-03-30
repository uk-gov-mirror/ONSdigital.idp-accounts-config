output "idp_iam_account_id" {
  value       = aws_organizations_account.idp_iam.id
  description = "The Id of the IDP IAM AWS account"
}

output "idp_mgmt_dev_account_id" {
  value       = module.idp_mgmt_dev.account_id
  description = "The Id of the IDP MGMT Dev AWS account"
}

output "idp_mgmt_account_id" {
  value       = module.idp_mgmt.account_id
  description = "The Id of the IDP MGMT AWS account"
}

output "idp_iam_s3_access_bucket_arn" {
  value       = aws_s3_bucket.splunk_logs.arn
  description = "The ARN of the IDP IAM splunk log delivery bucket"
}

output "idp_mgmt_dev_s3_access_bucket_arn" {
  value       = module.idp_mgmt_dev.s3_access_bucket_arn
  description = "The ARN of the IDP MGMT Dev splunk log delivery bucket"
}

output "idp_mgmt_s3_access_bucket_arn" {
  value       = module.idp_mgmt.s3_access_bucket_arn
  description = "The ARN of the IDP MGMT splunk log delivery bucket"
}
