resource "aws_s3_bucket" "test-user1-bucket" {
  bucket = "iam-test-user1-6030"

  tags = {
    Name = "Test user bucket"
  }
}

resource "aws_s3_bucket" "test-other-user1-bucket" {
  bucket = "iam-test-other-user1-6030"

  tags = {
    Name = "Test user bucket"
  }
}