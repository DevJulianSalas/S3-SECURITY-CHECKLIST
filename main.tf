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

//aws iam  policy document
data "aws_iam_policy_document" "deny_http_request" {
  statement {
    sid = "DenyHTTPRequests"
    effect = "Deny"
    condition {
      test =  "Bool"
      variable = "aws:SecureTransport"
      values = ["false"]

    }
    actions = [ 
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = [
      "${aws_s3_bucket.S3-security-checklist-bucket.arn}",
      "${aws_s3_bucket.S3-security-checklist-bucket.arn}/*"
    ]
    principals {
      type = "AWS"
      identifiers = ["${aws_iam_role.s3-security-checklist-role.arn}"]
    }
  }
}

//create Iam role to allow access to S3 from ec2 instance using profile instnace role
resource "aws_iam_role" "s3-security-checklist-role" {
  name = var.s3_iam_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}



//create S3 bucket policies
resource "aws_s3_bucket_policy" "s3-security-checklist-policies" {
  bucket = aws_s3_bucket.S3-security-checklist-bucket.id
  policy = data.aws_iam_policy_document.deny_http_request.json
}


//Create bucket
resource "aws_s3_bucket" "S3-security-checklist-bucket" {
  bucket = var.bucket_name
  tags = {
    Name = "tf-security-checklist-bucket"
    Environment = "staging"
  }
}