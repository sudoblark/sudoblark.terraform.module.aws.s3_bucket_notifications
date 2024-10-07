# Input variable definitions
variable "environment" {
  description = "Which environment this is being instantiated in."
  type        = string
  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "Must be either dev, test or prod"
  }
}

variable "application_name" {
  description = "Name of the application utilising resource."
  type        = string
}

variable "raw_notifications" {
  description = <<EOF

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
EOF


  type = object({
    lambda_notifications = optional(list(
      object({
        lambda_arn    = string,
        lambda_name   = string,
        events        = list(string),
        filter_prefix = optional(string, null),
        filter_suffix = optional(string, null),
        bucket        = string,
    })), [])
  })
}