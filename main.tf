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
    }]
  })
}

//Create bucket
resource "aws_s3_bucket" "S3-security-checklist-bucket" {
  bucket = "tf-security-checklist-bucket"
  tags = {
    Name = "tf-security-checklist-bucket"
    Environment = "staging"
  }
}