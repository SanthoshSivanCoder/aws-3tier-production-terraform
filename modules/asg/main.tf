resource "aws_launch_template" "app" {
  name_prefix   = "${terraform.workspace}-app-lt"
  image_id      = var.ami_id # Amazon Linux 2
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = var.ec2_sg_ids
  }

  user_data = filebase64("${path.module}/userdata.sh")

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${terraform.workspace}-app-instance"
    }
  }
}

resource "aws_autoscaling_group" "app" {
  name                = "${terraform.workspace}-app-asg"
  max_size            = var.max_size
  min_size            = var.min_size
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = var.private_subnet_ids

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  target_group_arns         = [var.target_group_arn]
  health_check_type         = "EC2"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "${terraform.workspace}-app-instance"
    propagate_at_launch = true
  }
}