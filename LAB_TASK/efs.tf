locals {
  efs_name = "ghost_content"
}


resource "aws_efs_file_system" "ghost" {
  creation_token   = local.efs_name
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = "true"

  tags = merge({ Name = local.efs_name }, var.base_tags)
}

resource "aws_efs_mount_target" "ghost_mt" {
  count           = local.pub_subnet_count
  file_system_id  = aws_efs_file_system.ghost.id
  subnet_id       = aws_subnet.public[count.index].id
  security_groups = ["${aws_security_group.efs.id}"]
}
