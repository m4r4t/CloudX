resource "aws_security_group" "test_sg" {
  name        = "allow_ssh"
  description = "allow ssh access"
  vpc_id      = aws_default_vpc.default.id
}

resource "aws_security_group_rule" "ssh_all" {
  security_group_id = aws_security_group.test_sg.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "egress_all" {
    security_group_id = aws_security_group.test_sg.id
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}