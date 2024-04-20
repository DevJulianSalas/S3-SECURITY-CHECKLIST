variable "region" {
  type = string
  description = "the aws region to execute the terraform module"
}

variable "profile" {
  type = string
  description = "the aws profile if you have multiple aws accounts/profiles"
}
variable "allow_bpa_group" {
  type = string
  description = "The group name that is allowed to change BPA settings"
}