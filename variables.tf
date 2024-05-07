variable "region" {
  type = string
  description = "the aws region to execute the terraform module"
}

variable "profile" {
  type = string
  description = "the aws profile if you have multiple aws accounts/profiles"
}
variable "deny_bpa_groups" {
  type = list
  description = "The group name list denies access to modify BPA settings"
}
variable "bucket_name" {
  type = string
  description = "The bucket name for testing purposes"
}
variable "s3_iam_role_name" {
  type = string
  description = "The s3 iam role name to attach to the bucket and ec2 instance to act as instance profile"
}

variable "server_access_logs_bucket_name" {
 type = string
 description = "The server access logs bucket name for testing purposes" 
}
variable "environment" {
  type = string
  description = "Environment" 
}
variable "abort_incomplete_multipart_upload_days" {
  type = number
  description = "The number of days affter which amazon s3 aborts an incomplete multipart upload"
}
variable "expiration_days_object" {
  type = number
  description = "The expiration days of the objects"
}
variable "lifecycle_rule_id" {
  type = string
  description = "the lifecycle rule id"
}