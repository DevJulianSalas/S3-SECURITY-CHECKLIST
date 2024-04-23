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