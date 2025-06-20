# Removed aws_access_key and aws_secret_key variables for security best practices.

# variable "bucket_name" {
#   type        = string
#   description = "Name of the S3 bucket for remote state"
# }

variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
}

