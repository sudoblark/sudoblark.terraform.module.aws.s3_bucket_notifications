locals {
  /*
    Here we simply restructure all notifications to be grouped by bucket rather than type, such that we can
    create a singular aws_s3_bucket_notification bucket resource per bucket as required by
    https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification
  */
  actual_notifications_by_bucket = {
    for bucket in local.actual_s3_buckets : bucket => {
      bucket_id : data.aws_s3_bucket.s3_buckets[bucket].id,
      lambda_notifications : flatten([
        for notification in var.raw_notifications.lambda_notifications : [notification.bucket == bucket ? notification : null]
      ])
    }
  }
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  for_each = local.actual_notifications_by_bucket

  eventbridge = true

  depends_on = [
    aws_lambda_permission.allow_lambda_execution_from_bucket,
    data.aws_s3_bucket.s3_buckets
  ]

  bucket = each.value["bucket_id"]

  dynamic "lambda_function" {
    for_each = each.value["lambda_notifications"]
    content {
      lambda_function_arn = lambda_function.value["lambda_arn"]
      events              = lambda_function.value["events"]
      filter_prefix       = lambda_function.value["filter_prefix"]
      filter_suffix       = lambda_function.value["filter_suffix"]
    }
  }
}