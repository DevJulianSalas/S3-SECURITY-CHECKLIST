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