output "aws_s3_bucket_test0_arn" {
  value = aws_s3_bucket.test0.arn
}

output "srv1_pub_ip" {
  value = aws_instance.srv1.public_ip
}

output "srv2_pub_ip" {
  value = aws_instance.srv2.public_ip
}

output "efs_dns_name" {
  value = aws_efs_file_system.test.dns_name
}