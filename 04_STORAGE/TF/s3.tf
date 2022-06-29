locals {
  s3_bucket0_name     = "cloudx-lab-bucket"
  s3_bucket0_tag_name = "S3 bucket for CloudX LAB"
}


resource "aws_s3_bucket" "test0" {
  bucket        = local.s3_bucket0_name
  force_destroy = true

  tags = merge({ Name = local.s3_bucket0_tag_name }, var.base_tags)
}