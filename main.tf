terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.45.0"
    }
  }
}
provider "aws" {
  region = var.region
  profile = var.profile

}

data "aws_iam_group" "get_iam_group" {
  for_each = {for name in var.deny_bpa_groups : name => name }
  group_name = each.key
}
resource "aws_s3_account_public_access_block" "this" {
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_policy" "deny_bpa_access" {
  name        = "DenyPublicAccessBlockSettings"
  path        = "/"
  description = "This policy deny users to modify block public access settings"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "s3:PutAccountPublicAccessBlock"
        Resource = "*"
        Effect = "Deny"
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "deny_bpa_access_policy_attach" {
  for_each = {for name, group in data.aws_iam_group.get_iam_group : name => group}
  group = each.key
  policy_arn = aws_iam_policy.deny_bpa_access.arn
}