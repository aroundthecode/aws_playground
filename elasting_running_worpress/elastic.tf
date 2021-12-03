data "aws_instance" "alive" {

  filter {
    name   = "image-id"
    values = [ "ami-63ec5b1e"]
  }

  filter {
    name   = "instance-state-name"
    values = [ "running"]
  }
  
}


resource "aws_eip" "bar" {
  vpc = true

  instance                  = data.aws_instance.alive.id
}