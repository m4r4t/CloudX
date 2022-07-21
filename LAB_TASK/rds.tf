locals {
  db_subnet_group_name = "ghost"
  db_name              = "ghost"
  db_username          = "ghost"
  db_secrets_name      = "/ghost/dbpassw-${random_id.id.hex}"
}

resource "random_password" "db_master_pass" {
  length           = 10
  special          = false
  //min_special      = 5
  //override_special = "!#$%^&*()-_=+[]{}<>:?"
}

resource "random_id" "id" {
  byte_length = 2
}

resource "aws_secretsmanager_secret" "db-pass" {

  //name = "db-pass-${random_id.id.hex}"
  name = local.db_secrets_name
}

resource "aws_secretsmanager_secret_version" "db-pass-val" {
  secret_id = aws_secretsmanager_secret.db-pass.id
  # encode in the required format
  secret_string = jsonencode(
    {
      username = aws_db_instance.ghost.username
      password = aws_db_instance.ghost.password
      engine   = "mysql"
      host     = aws_db_instance.ghost.endpoint
    }
  )
}


resource "aws_db_subnet_group" "mysql" {
  name        = local.db_subnet_group_name
  description = "ghost database subnet group"
  subnet_ids  = aws_subnet.private_db[*].id

  tags = merge({ Name = local.db_subnet_group_name }, var.base_tags)
}


resource "aws_db_instance" "ghost" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.db_instance_type
  db_name                = local.db_name
  username               = local.db_username
  password               = random_password.db_master_pass.result
  parameter_group_name   = "default.mysql8.0"
  db_subnet_group_name   = aws_db_subnet_group.mysql.name
  vpc_security_group_ids = [aws_security_group.mysql.id]
  multi_az               = false
  skip_final_snapshot    = true
}