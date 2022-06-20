resource "aws_key_pair" "test_key_pair" {
  key_name   = "deployer-key"
  public_key = file("${var.path_to_key}")
}