locals {
  // Wrap in toset to ensure uniqueness
  actual_s3_buckets = toset(flatten([
    for notification in var.raw_notifications.lambda_notifications : notification.bucket
  ]))
}

data "aws_s3_bucket" "s3_buckets" {
  for_each = local.actual_s3_buckets
  bucket   = each.value
}