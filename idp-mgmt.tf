module "idp_mgmt" {
  source  = "ONSdigital/account/aws"
  version = "~> 0.2.0"

  account_env          = "mgmt"
  account_team         = "cia"
  config_bucket        = data.terraform_remote_state.ons_tfstate.config_bucket_name
  config_sns_topic_arn = data.terraform_remote_state.ons_tfstate.config_bucket_name
  dns_subdomain        = "mgmt.idp"
  iam_account_id       = aws_organizations_account.idp_iam.id
  master_zone_id       = data.terraform_remote_state.ons_tfstate.master_zone_id
  name                 = "idp-mgmt"
  root_account_email   = "aws-registration.ons.048@ons.gov.uk"
  splunk_user_arn      = data.terraform_remote_state.ons_tfstate.splunk_user_arn
  splunk_logs_sqs_arn  = data.terraform_remote_state.ons_tfstate.ons_s3_access_sqs_queue_arn
}
