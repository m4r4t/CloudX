output "srv1_pub_ip" {
  value = aws_instance.srv1.public_ip
}


output "srv2_pub_ip" {
  value = aws_instance.winsrv1.public_ip
}
