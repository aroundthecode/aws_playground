data "aws_ami" "image" {
  most_recent = true
  
  filter {
    name   = "image-id"
    values = ["ami-0747a6dacee58afc0"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["679593333241"] 
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.image.id
  instance_type = "t2.micro"

  key_name      = data.aws_key_pair.deploy.key_name

  network_interface {
    network_interface_id = aws_network_interface.web-ani.id
    device_index         = 0
  }

  tags = {
    Name = "HelloWorld"
  }
}
#### internal IP configuration

resource "aws_network_interface" "web-ani" {
  subnet_id   = aws_subnet.management.id
  private_ips = ["10.3.1.100"]

  tags = {
    Name = "primary_network_interface"
  }
}
#### elastic IP configuration
resource "aws_eip" "web-eip" {
  vpc = true

  instance                  = aws_instance.web.id
  associate_with_private_ip = "10.3.1.100"
  depends_on                = [aws_internet_gateway.gw]
}


##### attach additional disk 
resource "aws_ebs_volume" "data" {
  availability_zone = "${var.aws_region}a"
  size              = 5

  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_volume_attachment" "data_attach" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.data.id
  instance_id = aws_instance.web.id
}


### SSH Key ###
data "aws_key_pair" "deploy" {
  key_name = "deploykey"
}

### security group ###
resource "aws_network_interface_sg_attachment" "sg_ssh_attachment" {
  security_group_id    = aws_security_group.allow_ssh.id
  network_interface_id = aws_instance.web.primary_network_interface_id
}

resource "aws_network_interface_sg_attachment" "sg_web_attachment" {
  security_group_id    = aws_security_group.allow_web.id
  network_interface_id = aws_instance.web.primary_network_interface_id
}