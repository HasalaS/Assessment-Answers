variable "aws_region" {
  description = "The AWS region to deploy to"
  default     = "us-west-2"
}

variable "s3_bucket" {
  description = "S3 bucket for Terraform state"
}

variable "dynamodb_table" {
  description = "DynamoDB table for Terraform state locking"
}
