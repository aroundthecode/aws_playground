resource "aws_eip" "elastic_wordpress" {
  vpc = true
  tags = {
    Name = "wordpress"
    project = "vpc_ha"
  }
}
