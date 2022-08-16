locals {
  alb_name         = "ghost-alb"
  launch_tplt_name = "ghost"
  tg_name          = "ghost-ec2"
  ecs_tg_name      = "ghost-fargate"
  asg_name         = "ghost_ec2_pool"
  asg_max          = 3
  asg_min          = 2
  asg_desired      = 3
  app_port         = 2368
  db_url           = aws_db_instance.ghost.address
  db_user          = aws_db_instance.ghost.username
  //az_ids = data.aws_availability_zones.available.id
}

resource "aws_launch_template" "ghost" {
  name     = local.launch_tplt_name
  image_id = data.aws_ami.amazon_linux_2.id
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_ghost_profile.name
  }
  instance_type          = var.instance_type
  key_name               = aws_key_pair.lab_key_pair.id
  vpc_security_group_ids = [aws_security_group.ec2_pool.id]
  user_data              = base64encode(templatefile("ghost_app.sh", { LB_DNS_NAME = aws_lb.ghost_app.dns_name, DB_URL = local.db_url, DB_USER = local.db_user, DB_NAME = local.db_name, DB_SECRET_NAME = local.db_secrets_name }))
  //user_data              = filebase64("ghost_app.sh")

  lifecycle {
    create_before_destroy = true
  }

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "ec2-pool"
    }
  }

  depends_on = [
    aws_db_instance.ghost
  ]

}

resource "aws_lb" "ghost_app" {
  name               = local.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]
}

resource "aws_lb_target_group" "ghost" {
  name     = local.tg_name
  port     = local.app_port
  protocol = "HTTP"


  stickiness {
    type = "lb_cookie"
  }

  vpc_id = aws_vpc.lab1.id

  health_check {
    path = "/"
    port = local.app_port
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "listener_http" {
  load_balancer_arn = aws_lb.ghost_app.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"

    forward {
      target_group {
        arn    = aws_lb_target_group.ghost.arn
        weight = 50
      }

      target_group {
        arn    = aws_lb_target_group.ecs.arn
        weight = 50
      }

      stickiness {
        enabled  = true
        duration = 600
      }

    }
  }


}

resource "aws_autoscaling_group" "ghost" {
  name                = local.asg_name
  vpc_zone_identifier = [for subnet in aws_subnet.public : subnet.id]
  desired_capacity    = local.asg_desired
  max_size            = local.asg_max
  min_size            = local.asg_min

  target_group_arns = ["${aws_lb_target_group.ghost.arn}"]

  launch_template {
    id      = aws_launch_template.ghost.id
    version = "$Latest"
  }
}

//------------------------------------------------------------------
resource "aws_lb_target_group" "ecs" {
  name     = local.ecs_tg_name
  port     = local.app_port
  protocol = "HTTP"

  target_type = "ip"
  vpc_id      = aws_vpc.lab1.id

  /*
  stickiness {
    type = "lb_cookie"
  }
*/
  slow_start = 240

  health_check {
    path     = "/"
    port     = local.app_port
    interval = 60
    timeout  = 30
    //matcher = "200,503"
  }

  lifecycle {
    create_before_destroy = true
  }
}