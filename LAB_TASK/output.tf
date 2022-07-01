output "bastion_ip" {
  value = aws_instance.bastion.public_ip
}


output "alb_dns" {
  value = aws_lb.ghost_app.dns_name
}

/*
output "srv1_pub_ip" {
  value = aws_instance.srv1.public_ip
}

output "srv2_pub_ip" {
  value = aws_instance.srv2.public_ip
}

output "efs_dns_name" {
  value = aws_efs_file_system.test.dns_name
}
*/