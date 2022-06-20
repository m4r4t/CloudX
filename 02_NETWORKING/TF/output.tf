output "vpc1_id" {
  value = module.vpc1.vpc_id
}

output "vpc2_id" {
  value = module.vpc2.vpc_id
}

output "vpc3_id" {
  value = module.vpc3.vpc_id
}

output "srv1_pub_ip" {
  value = aws_instance.srv1.public_ip
}

output "srv2_pub_ip" {
  value = aws_instance.srv2.public_ip
}

output "srv3_pub_ip" {
  value = aws_instance.srv3.public_ip
}