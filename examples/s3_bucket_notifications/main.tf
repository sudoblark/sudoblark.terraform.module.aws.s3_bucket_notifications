terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.61.0"
    }
  }
  required_version = "~> 1.5.0"
}

provider "aws" {
  region = "eu-west-2"
}

module "s3_bucket_notifications" {
  #source = "github.com/sudoblark/sudoblark.terraform.module.aws.s3_bucket_notifications?ref=1.0.0"
  source = "../../"

  raw_notifications = local.raw_s3_bucket_notifications
}
