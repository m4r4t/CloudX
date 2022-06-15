resource "aws_iam_policy" "ec2_policy" {
  name        = "ec2_policy"
  path        = "/"
  description = "Allow s3 access for ec2 instance"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:Get*",
          "s3:List*"
        ],
        Resource = [
          aws_s3_bucket.test-user1-bucket.arn,
          aws_s3_bucket.test-other-user1-bucket.arn,
        ]
      },
      {
        Action = [
          "s3:ListAllMyBuckets",
          "s3:GetBucketLocation"
        ],
        Effect = "Allow",
        Resource = [
          "arn:aws:s3:::*"
        ]
      }
    ]

  })
}


resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"
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
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "ec2_policy_role" {
  name       = "ec2_attachement"
  roles      = [aws_iam_role.ec2_role.name]
  policy_arn = aws_iam_policy.ec2_policy.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_role.name
}