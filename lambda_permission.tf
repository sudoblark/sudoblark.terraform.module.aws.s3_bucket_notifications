locals {
  lambda_permissions = flatten([
    for notification in var.raw_notifications.lambda_notifications : {
      key : "${notification.bucket}/${notification.lambda_name}"
      function_name = notification.lambda_name
      source_arn    = data.aws_s3_bucket.s3_buckets[notification.bucket].arn
    }
  ])
}

resource "aws_lambda_permission" "allow_lambda_execution_from_bucket" {
  for_each = { for permission in local.lambda_permissions : permission.key => permission }

  depends_on = [
    data.aws_s3_bucket.s3_buckets
  ]

  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = each.value["function_name"]
  principal     = "s3.amazonaws.com"
  source_arn    = each.value["source_arn"]
}
