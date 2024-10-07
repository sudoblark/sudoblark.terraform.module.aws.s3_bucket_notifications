/*
Data structure
---------------
A dictionary of dictionaries, permissible keys are outlined below:

OPTIONAL
---------
- lambda_notifications  : A list of dictionaries with the following attributes:
-- lambda_arn           : The ARN of the lambda triggered by this notification
-- lambda_name          : The function name of the lambda triggered by this notification
-- events               : A list of strings, where each string is an event which triggers the notification
-- filter_prefix        : A prefix to filter S3 objects by in relation to the events
-- filter_suffix        : A suffix to filter S3 objects by in relation to the events
-- bucket               : The bucket we are creating an event for
 */

locals {
  raw_s3_bucket_notifications = {
    "lambda_notifications" : [
      {
        lambda_arn : "arn:aws:lambda:${data.aws_region.current_region.name}:${data.aws_caller_identity.current_account.id}:function:pet-dog"
        lambda_name : "pet-dog"
        events = [
          "s3:ObjectCreated:*"
        ]
        filter_prefix = "dogs/"
        filter_suffix = ".png"
        bucket        = "dummy-bucket"
      },
      {
        lambda_arn : "arn:aws:lambda:${data.aws_region.current_region.name}:${data.aws_caller_identity.current_account.id}:function:pet-cat"
        lambda_name : "pet-cat"
        events = [
          "s3:ObjectCreated:*"
        ]
        filter_prefix = "cats/"
        filter_suffix = ".png"
        bucket        = "dummy-bucket"
      },
    ]
  }
}