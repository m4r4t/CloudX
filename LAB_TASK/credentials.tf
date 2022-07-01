resource "aws_key_pair" "lab_key_pair" {
  key_name   = "ghost-ec2-pool"
  public_key = file("${var.path_to_key}")
}