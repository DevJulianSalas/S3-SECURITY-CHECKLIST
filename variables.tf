variable "region" {
  type = string
  description = "the aws region to execute the terraform module"
}

variable "profile" {
  type = string
  description = "the aws profile if you have multiple aws accounts/profiles"
}

# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Deny",
#             "Action": [
#                 "s3:PutAccountPublicAccessBlock"
#             ],
#             "Resource": "*",
#             "Condition": {
#                 "ArnNotLike": {
#                     "aws:PrincipalARN": "arn:aws:iam::${Account}:role/[PRIVILEGED_ROLE]"
#                 }
#             }
#         }
#     ]
# }