data "aws_iam_policy_document" "deny_leaving_org" {
  statement {
    sid    = "DenyLeavingOrg"
    effect = "Deny"

    actions = [
      "organizations:LeaveOrganization"
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "deny_deletion_specific_resources" {
  statement {
    sid    = "DenyDeletingKMSKeys"
    effect = "Deny"

    actions = [
      "kms:ScheduleKeyDeletion",
      "kms:Delete*"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "DenyDeletingZones"
    effect = "Deny"

    actions = [
      "route53:DeleteHostedZone"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "DenyDeletingCloudWatchLogs"
    effect = "Deny"

    actions = [
      "ec2:DeleteFlowLogs",
      "logs:DeleteLogGroup",
      "logs:DeleteLogStream"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "DenyDeletingFlowLogs"
    effect = "Deny"

    actions = [
      "ec2:DeleteFlowLogs",
      "logs:DeleteLogGroup",
      "logs:DeleteLogStream"
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "require_s3_encryption" {
  statement {
    sid       = "RequireValidEncryption"
    effect    = "Deny"
    actions   = ["s3:PutObject"]
    resources = ["*"]

    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["AES256"]
    }
  }
  statement {
    sid       = "RequireEncryption"
    effect    = "Deny"
    actions   = ["s3:PutObject"]
    resources = ["*"]

    condition {
      test     = "Null"
      variable = "s3:x-amz-server-side-encryption"
      values   = [true]
    }
  }
}

data "aws_iam_policy_document" "restrict_regions" {
  statement {
    sid    = "RestrictRegions"
    effect = "Deny"

    # These actions do not operate in a specific region, or only run in
    # a single region, so we don't want to try restricting them by region.
    not_actions = [
      "budgets:*",
      "cloudfront:*",
      "globalaccelerator:*",
      "iam:*",
      "importexport:*",
      "organizations:*",
      "route53:*",
      "sts:*",
      "support:*",
      "waf:*"
    ]

    resources = ["*"]

    condition {
      test     = "StringNotEquals"
      variable = "aws:RequestedRegion"
      values   = var.allowed_regions
    }
  }
}

data "aws_iam_policy_document" "config_recorder" {
  statement {
    sid    = "DenyUnsecuredTransport"
    effect = "Allow"

    actions = [
      "s3:*",
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"

      values = [
        "true",
      ]
    }

    principals {
      type        = "Service"
      identifiers = [aws_iam_service_linked_role.config_recorder.aws_service_name]
    }

    resources = [
      aws_s3_bucket.config_recorder.arn,
      "${aws_s3_bucket.config_recorder.arn}/*",
    ]
  }
}

data "aws_iam_policy_document" "org_config_assume_role" {
  statement {
    sid    = "OrgConfigAssume"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = [aws_iam_service_linked_role.config_recorder.aws_service_name]
    }

    actions = ["sts:AssumeRole"]
  }
}
