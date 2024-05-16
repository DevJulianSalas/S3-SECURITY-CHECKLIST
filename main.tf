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
  for_each = aws_s3_bucket.buckets
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
      "${aws_s3_bucket.buckets[each.key].arn}",
      "${aws_s3_bucket.buckets[each.key].arn}/*",
    ]
    principals {
      type = "AWS"
      identifiers = ["${aws_iam_role.s3-security-checklist-role.arn}"]
    }
  }
}

data "aws_iam_policy_document" "delegating_access_control_to_access_point" {
  statement {
    sid = "DelegatingAccessControlToAccessPoint"
    effect = "Allow"
    actions = var.s3_access_point_actions_policy
    resources = [ 
      "${aws_s3_bucket.buckets[0].arn}",
      "${aws_s3_bucket.buckets[0].arn}/*",
    ]
    condition {
      test = "StringEquals"
      variable = "DataAccessPointArn"
      values = [aws_s3_access_point.s3-access_point.arn]
    }
    principals {
      type        = "AWS"
      identifiers = [aws_s3_access_point.s3-access_point.arn]
    }
  }
}

data "aws_vpc" "selected" {
  id = var.vpc_id
  tags = {
    Name = var.vpc_name
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
# resource "aws_s3_bucket_policy" "s3-security-checklist-policies" {
#   for_each = aws_s3_bucket.buckets
#   bucket = aws_s3_bucket.buckets[1].id
#   policy = data.aws_iam_policy_document.deny_http_request[each.key].json
# }

resource "aws_s3_bucket_policy" "s3-security-checklist-fullaccess-to-access-point" {
  bucket = aws_s3_bucket.buckets[0].id
  policy = data.aws_iam_policy_document.delegating_access_control_to_access_point.json
}

//Create buckets
resource "aws_s3_bucket" "buckets" {
  for_each = {for idx, name in var.bucket_names : idx => name}
  bucket = each.value
  tags = {
    Name = each.value
    Environment = var.environment
  }
}
//create lifecycle rules to cost-optimization server access log bucket and bucket security list
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle-s3-rules" {
  for_each = aws_s3_bucket.buckets
  bucket = aws_s3_bucket.buckets[each.key].id
  rule {
    id =  var.lifecycle_rule_id
    status = "Enabled"
    abort_incomplete_multipart_upload {
      days_after_initiation =   var.abort_incomplete_multipart_upload_days
    }
    expiration {
      days = var.expiration_days_object
    }
    transition {
      storage_class = "INTELLIGENT_TIERING"
      days = 0
    }
  }
}

# //create server access logs bucket
resource "aws_s3_bucket_logging" "s3-logging" {
  bucket = aws_s3_bucket.buckets[0].id
  target_bucket = aws_s3_bucket.buckets[1].id
  target_prefix = "logs/"
}

//S3 access point
resource "aws_s3_access_point" "s3-access_point" {
  name = var.s3_access_point_name
  bucket = aws_s3_bucket.buckets[0].id
  
  vpc_configuration {
    vpc_id = data.aws_vpc.selected.id
  }
  public_access_block_configuration {
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }
}
