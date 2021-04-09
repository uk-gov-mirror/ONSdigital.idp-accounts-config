data "aws_iam_policy_document" "terraform_state" {
  statement {
    sid    = "listBucket"
    effect = "Allow"

    actions = [
      "s3:ListBucket",
    ]

    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::974325445151:user/ci"]
    }

    resources = [aws_s3_bucket.terraform_state.arn]
  }

  statement {
    sid    = "readWrite"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::974325445151:user/ci"]
    }

    resources = ["${aws_s3_bucket.terraform_state.arn}/*"]
  }
}
