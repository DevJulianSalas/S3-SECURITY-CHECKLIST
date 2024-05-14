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
variable "bucket_names" {
  type = list(string)
  description = "The bucket list name for testing purposes"
}
variable "s3_iam_role_name" {
  type = string
  description = "The s3 iam role name to attach to the bucket and ec2 instance to act as instance profile"
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
variable "s3_access_point_name" {
  type = string
  description = "the s3 access point name to attach to s3 main bucket"  
}
variable "vpc_id" {
  type = string
  description = "the vpc id to idenfity as filter and use it as network origin."
}
variable "vpc_name" {
  type = string
  description = "the vpc name to idenfity as filter and use it as network origin."
}