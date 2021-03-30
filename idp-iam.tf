resource "aws_organizations_account" "idp_iam" {
  name  = "idp-iam"
  email = "aws-registration.ons.047@ons.gov.uk"

  tags = {
    team = "cia"
    env  = "iam"
  }

  provisioner "local-exec" {
    # AWS accounts aren't quite ready on creation, arbitrary pause before we provision resources inside it
    command = "sleep 120"
  }
}

resource "aws_iam_service_linked_role" "config" {
  aws_service_name = "config.amazonaws.com"
}

resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 14
  require_uppercase_characters   = true
  require_lowercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  max_password_age               = 30
  hard_expiry                    = false
  allow_users_to_change_password = true
  password_reuse_prevention      = 10
}

##############################################
#             Config Recorder               #
#############################################

resource "aws_config_configuration_recorder" "config_recorder" {
  name     = "config-recorder-${aws_organizations_account.idp_iam.id}"
  role_arn = aws_iam_service_linked_role.config.arn

  recording_group {
    include_global_resource_types = true
  }
}

resource "aws_config_configuration_recorder_status" "config_recorder_status" {
  depends_on = [aws_config_delivery_channel.config_delivery_channel]

  name       = aws_config_configuration_recorder.config_recorder.name
  is_enabled = true
}

resource "aws_config_delivery_channel" "config_delivery_channel" {
  depends_on = [aws_config_configuration_recorder.config_recorder]

  name           = "config-delivery-channel-${aws_organizations_account.idp_iam.id}"
  s3_bucket_name = data.terraform_remote_state.ons_tfstate.config_bucket_name
  sns_topic_arn  = data.terraform_remote_state.ons_tfstate.config_bucket_name
}

##############################################
#                  DNS                      #
#############################################

resource "aws_route53_zone" "zone" {
  name = "iam.idp.aws.onsdigital.uk"
}

resource "aws_route53_record" "account_aws_onsdigital_uk_ns" {
  zone_id = data.terraform_remote_state.ons_tfstate.master_zone_id
  name    = "${aws_route53_zone.zone.name}."
  type    = "NS"
  ttl     = "300"

  records = aws_route53_zone.zone.name_servers
}

##############################################
#               Splunk Logs                 #
#############################################

data "aws_iam_policy_document" "splunk_logs" {
  statement {
    sid    = "SplunkAccess"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [data.terraform_remote_state.ons_tfstate.splunk_user_arn]
    }

    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.splunk_logs.arn}/*"]
  }
}

resource "aws_s3_bucket" "splunk_logs" {
  bucket = "idp-iam-s3-access"
  acl    = "log-delivery-write"

  policy = data.aws_iam_policy_document.splunk_logs.json

  lifecycle_rule {
    id      = "log"
    enabled = true

    expiration {
      days = 60
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "splunk_logs" {
  bucket                  = aws_s3_bucket.splunk_logs[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_notification" "splunk_logs" {
  bucket = aws_s3_bucket.splunk_logs[0].id

  queue {
    queue_arn = data.terraform_remote_state.ons_tfstate.ons_s3_access_sqs_queue_arn
    events    = ["s3:ObjectCreated:*"]
  }
}
