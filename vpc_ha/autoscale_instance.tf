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
  vpc_zone_identifier    = [for subnet in aws_subnet.private : "${subnet.id}"]
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