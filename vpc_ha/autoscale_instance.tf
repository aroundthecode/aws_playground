#CentOs Wordpress
data "aws_ami" "wordpress" {
  most_recent = true
  
  filter {
    name   = "image-id"
    values = ["ami-63ec5b1e"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["679593333241"] 
}

resource "aws_launch_configuration" "launch_wordpress" {
  name_prefix   = "ha_wordpress-"
  image_id      = data.aws_ami.wordpress.id
  instance_type = "t2.micro"

  key_name      = data.aws_key_pair.deploy.key_name
  lifecycle {
    create_before_destroy = true
  }
  security_groups = [ 
      aws_security_group.allow_web.id
      ]

}

resource "aws_autoscaling_group" "autoscale_single" {
  name                  = "single_ha_wordpress"
  launch_configuration  = aws_launch_configuration.launch_wordpress.name
  vpc_zone_identifier    = [for subnet in aws_subnet.public : "${subnet.id}"]
  min_size              = 1
  max_size              = 1
  desired_capacity        = 1
  lifecycle {
    create_before_destroy = true
  }
  
}

### SSH Key ###
data "aws_key_pair" "deploy" {
  key_name = "deploykey"
}


#### lifecycle management ###

resource "aws_autoscaling_lifecycle_hook" "insance_start_hook" {
  name                   = "ec2_instance_start"
  autoscaling_group_name = aws_autoscaling_group.autoscale_single.name
  default_result         = "CONTINUE"
  heartbeat_timeout      = 30
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_LAUNCHING"

  notification_metadata = <<EOF
{
  "project": "vpc_ha"
}
EOF

}
resource "aws_cloudwatch_event_rule" "scale_event" {
  name        = "capture-ec2-scale"
  description = "Capture EC2 instance scaling up"

  event_pattern = <<EOF
{
  "source": ["aws.autoscaling"],
  "detail-type": ["EC2 Instance-launch Lifecycle Action"],
  "detail": {
    "AutoScalingGroupName": ["single_ha_wordpress"]
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "lambda_eip_target" {
  rule      = aws_cloudwatch_event_rule.scale_event.name
  target_id = "ReassignEipLambda"
  arn       = aws_lambda_function.elastic.arn
}