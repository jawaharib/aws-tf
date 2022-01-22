locals {
  prevent_unencrypted_uploads = var.prevent_unencrypted_uploads && var.enable_server_side_encryption ? true : false
  state_bucket                = "${var.env}-${var.bucket_purpose}-${var.region}"
  logging_bucket              = "${var.env}-${var.bucket_purpose}-${var.log_name}-${var.region}"
  policy = local.prevent_unencrypted_uploads ? join(
    "",
    data.aws_iam_policy_document.prevent_unencrypted_uploads.*.json
  ) : ""
}

resource "aws_s3_bucket" "log_bucket" {
  bucket        = local.logging_bucket
  tags          = var.s3_bucket_tags
  acl           = "log-delivery-write"
  force_destroy = var.force_destroy

  versioning {
    enabled = false
  }

  lifecycle_rule {
    id      = var.log_name
    enabled = true

    tags = {
      rule      = var.log_name
      autoclean = "true"
    }

    expiration {
      days = var.log_retention
    }
  }
}

resource "aws_s3_bucket" "state_bucket" {
  bucket        = local.state_bucket
  acl           = "private"
  tags          = var.s3_bucket_tags
  force_destroy = var.force_destroy

  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "log/"
  }

  versioning {
    enabled    = false
    mfa_delete = var.mfa_delete
  }
}

resource "aws_s3_bucket_public_access_block" "default" {
  count                   = var.enable_public_access_block ? 1 : 0
  bucket                  = aws_s3_bucket.state_bucket.id
  block_public_acls       = var.block_public_acls
  ignore_public_acls      = var.ignore_public_acls
  block_public_policy     = var.block_public_policy
  restrict_public_buckets = var.restrict_public_buckets
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = var.dynamodb_table_name
  hash_key       = "LockID"
  read_capacity  = 2
  write_capacity = 2

  server_side_encryption {
    enabled = var.enable_server_side_encryption
  }

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = var.dynamodb_table_tags
}
