resource "aws_iam_policy" "flow_log" {
  name        = "vpc_flowlog_policy"
  path        = "/"
  description = "Allow to gather vpc flow logs"

  policy = jsonencode(
    {
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "logs:DescribeLogGroups",
            "logs:DescribeLogStreams"
        ],
        Resource =  ["*"]
    }
    ]
    }
   )
}

resource "aws_iam_role" "vpc_flow_log" {
  name = "vpc_flow_log_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "vpc_flow_log_role" {
  name       = "vpc_flow_log_role_attachement"
  roles      = [aws_iam_role.vpc_flow_log.name]
  policy_arn = aws_iam_policy.flow_log.arn
}


resource "aws_flow_log" "vpc1" {
  iam_role_arn    = aws_iam_role.vpc_flow_log.arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_log.arn
  traffic_type    = "ALL"
  vpc_id          = module.vpc1.vpc_id
}

resource "aws_flow_log" "vpc2" {
  iam_role_arn    = aws_iam_role.vpc_flow_log.arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_log.arn
  traffic_type    = "ALL"
  vpc_id          = module.vpc2.vpc_id
}

resource "aws_flow_log" "vpc3" {
  iam_role_arn    = aws_iam_role.vpc_flow_log.arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_log.arn
  traffic_type    = "ALL"
  vpc_id          = module.vpc3.vpc_id
}

resource "aws_cloudwatch_log_group" "vpc_flow_log" {
  name = "VPC-Flow-Log-group"
}