locals {
  efs_tag_name = "Test EFS"
}


resource "aws_efs_file_system" "test" {
  creation_token   = "efs-test"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = "true"

  tags = merge({ Name = local.efs_tag_name }, var.base_tags)

}

resource "aws_efs_mount_target" "az1" {
  file_system_id  = aws_efs_file_system.test.id
  subnet_id       = aws_default_subnet.az1.id
  security_groups = ["${aws_security_group.ingress-efs-test.id}"]
}

resource "aws_efs_mount_target" "az2" {
  file_system_id  = aws_efs_file_system.test.id
  subnet_id       = aws_default_subnet.az2.id
  security_groups = ["${aws_security_group.ingress-efs-test.id}"]
}