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
  group_name = var.allow_bpa_group
}


resource "aws_s3_account_public_access_block" "this" {
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_policy" "allow_bpa_access" {
  name        = "DenyPublicAccessBlockSettings"
  path        = "/"
  description = "This policy allow certain selected users to modify block public access settings"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "s3:PutAccountPublicAccessBlock"
        Resource = "*"
        Effect = "Allow"
        Condition = {
          StringEquals = {
            "aws:userid" = ["${data.aws_iam_group.get_iam_group.arn}"]
          }
        }
      },
      {
        Action = "s3:PutAccountPublicAccessBlock"
        Resource = "*"
        Effect = "Deny"
      }
    ]
  })
}