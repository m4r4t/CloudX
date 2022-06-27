locals {
  launch_template_name = "CloudX-LaunchTemplate"
  asg_name             = "CloudX-ASG"
}




resource "aws_launch_template" "cloudx" {
  name_prefix          = local.launch_template_name
  image_id             = data.aws_ami.ubuntu.id
  instance_type        = var.asg_instance_type
  key_name             = aws_key_pair.test_key_pair.id
  user_data            = base64encode(templatefile("user-data-http.sh", { http_port = var.http_port }))
  security_group_names = [aws_security_group.public_access_linux.name]
}

resource "aws_autoscaling_group" "cloudx" {
  name               = local.asg_name
  availability_zones = data.aws_availability_zones.available.names
  desired_capacity   = 2
  max_size           = 3
  min_size           = 2

  launch_template {
    id      = aws_launch_template.cloudx.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }
}