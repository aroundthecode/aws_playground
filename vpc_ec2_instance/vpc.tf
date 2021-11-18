#### VPC Network isolato
resource "aws_vpc" "main" {
  cidr_block = "10.3.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "test-vpc"
    project = "vpc_ec2_instance"
  }
}

### Gateway pubblico per uscire verso internet
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

# subnet assoviate al GW pubblico
resource "aws_subnet" "management" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.3.1.0/24"
  availability_zone = "${var.aws_region}a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "manamgement-subnet"
    project = "vpc_ec2_instance"
  }
}

# Routing table per instradare il traffico verso l'esterno
resource "aws_route_table" "rtb_public" {
  vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gw.id}"
    }
}

# associazione della routing table alla subnet di management
resource "aws_route_table_association" "rta_subnet_public" {
  subnet_id      = "${aws_subnet.management.id}"
  route_table_id = "${aws_route_table.rtb_public.id}"
}

# aperture per HTTP e HTTPS in ingresso e qualsiasi cosa in uscita
resource "aws_security_group" "allow_web" {
  name        = "allow_web"
  description = "Allow http and https inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTPS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    description      = "Enable Anything outgoing"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_web"
    project = "vpc_ec2_instance"
  }
}

# aperture per SSH in ingresso
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh connection"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
    project = "vpc_ec2_instance"
  }
}