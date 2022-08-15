locals {
  ecr_name         = "ghost"
  task_def_name    = "task_def_ghost"
  db_pass_for_ecs  = jsondecode(aws_secretsmanager_secret_version.db-pass-val.secret_string)["password"]
  ecs_cluster_name = "ghost"
  ecs_svc_name     = "ghost"
  //ecr_image        = "047259566030.dkr.ecr.eu-west-1.amazonaws.com/ghost:4.12"
  ecr_image        = "ghost:5"
  ecs_log_group_name = "ECS-Fargate"
}


resource "aws_ecs_task_definition" "ghost" {
  family                   = local.task_def_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 1024
  task_role_arn            = aws_iam_role.ecs.arn
  execution_role_arn       = aws_iam_role.ecs.arn

  volume {
    name = "ghost_volume"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.ghost.id

    }
  }

  container_definitions = templatefile("container_definition.tftpl", { LB_DNS_NAME = aws_lb.ghost_app.dns_name,
                                                                       TASK_NAME = local.task_def_name, 
                                                                       ECR_IMAGE = local.ecr_image, 
                                                                       DB_URL = local.db_url, 
                                                                       DB_USER = local.db_username, 
                                                                       PASS = local.db_pass_for_ecs, 
                                                                       DB_NAME = local.db_name,
                                                                       LOG_GROUP_NAME = local.ecs_log_group_name,
                                                                       REGION_NAME = data.aws_region.current.name 
                                                                      })
}

resource "aws_ecs_cluster" "ghost" {
  name = local.ecs_cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_service" "ghost" {
  name            = local.ecs_svc_name
  cluster         = aws_ecs_cluster.ghost.id
  task_definition = aws_ecs_task_definition.ghost.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.fargate_pool.id]
    subnets          = aws_subnet.ecs_fargate.*.id
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs.arn
    container_name   = local.task_def_name
    container_port   = local.app_port
  }

  depends_on = [aws_lb_listener.listener_http]
}


resource "aws_cloudwatch_log_group" "ecs" {
  name = local.ecs_log_group_name
  retention_in_days = 1
}
//------------------------------------------------------------
/*
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id = aws_vpc.lab1.id
  service_name = "com.amazonaws.${data.aws_region.current.name}.ecr.api"
  vpc_endpoint_type = "Interface"

  security_group_ids = [aws_security_group.fargate_pool.id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id = aws_vpc.lab1.id
  service_name = "com.amazonaws.${data.aws_region.current.name}.ecr.dkr"
  vpc_endpoint_type = "Interface"

  security_group_ids = [aws_security_group.fargate_pool.id]
  private_dns_enabled = true
}
*/