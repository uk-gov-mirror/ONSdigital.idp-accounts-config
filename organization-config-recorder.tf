resource "aws_config_configuration_recorder" "config_recorder" {
  name     = "config-recorder-${aws_organizations_organization.aws_d.master_account_id}"
  role_arn = aws_iam_service_linked_role.config_recorder.arn

  recording_group {
    include_global_resource_types = true
  }
}

resource "aws_config_configuration_recorder_status" "config_recorder_status" {
  depends_on = [aws_config_delivery_channel.config_recorder_delivery_channel]

  name       = aws_config_configuration_recorder.config_recorder.name
  is_enabled = true
}

resource "aws_config_configuration_aggregator" "config_recorder_aggregator" {
  name = aws_config_configuration_recorder.config_recorder.name

  organization_aggregation_source {
    regions  = var.allowed_regions
    role_arn = aws_iam_role.config_recorder_aggregator_role.arn
  }
}

resource "aws_config_delivery_channel" "config_recorder_delivery_channel" {
  depends_on = [aws_config_configuration_recorder.config_recorder]

  name           = "config-delivery-channel-${aws_organizations_organization.aws_d.master_account_id}"
  s3_bucket_name = aws_s3_bucket.config_recorder.id
  sns_topic_arn  = aws_sns_topic.config_recorder.arn

  snapshot_delivery_properties {
    delivery_frequency = "TwentyFour_Hours"
  }
}

resource "aws_s3_bucket" "config_recorder" {
  bucket = "config-recorder-${aws_organizations_organization.aws_d.master_account_id}"
  acl    = "log-delivery-write"

  lifecycle {
    prevent_destroy = true
  }

  lifecycle_rule {
    id      = "log"
    enabled = true

    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }
}

resource "aws_s3_bucket_policy" "config_recorder" {
  bucket = aws_s3_bucket.config_recorder.id
  policy = data.aws_iam_policy_document.config_recorder.json
}

resource "aws_iam_service_linked_role" "config_recorder" {
  aws_service_name = "config.amazonaws.com"
}

resource "aws_iam_role" "config_recorder_aggregator_role" {
  assume_role_policy = data.aws_iam_policy_document.org_config_assume_role.json
}

resource "aws_iam_role_policy_attachment" "config_recorder_aggregator_role" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRoleForOrganizations"
  role       = aws_iam_role.config_recorder_aggregator_role.name
}

resource "aws_sns_topic" "config_recorder" {
  name = "config-recorder-${aws_organizations_organization.aws_d.master_account_id}"
}
