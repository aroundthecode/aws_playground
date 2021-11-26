#### VPC Network isolato
resource "aws_vpc" "main" {
  cidr_block = "10.3.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "ha-vpc"
    project = "vpc_ha"
  }
}

# Avaliability zones in my region
data "aws_availability_zones" "available" {
  state = "available"
}

# Public subnet for each availability zone
resource "aws_subnet" "public" {
  for_each = toset(data.aws_availability_zones.available.names)
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.3.${ index(data.aws_availability_zones.available.names, each.value)+1}.0/24"
  availability_zone = each.value

  tags = {
    Name = "public_subnet_${ index(data.aws_availability_zones.available.names, each.value)}"
    project = "vpc_ha"
  }
}

# Private subnet for each availability zone
resource "aws_subnet" "private" {
  for_each = toset(data.aws_availability_zones.available.names)
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.3.${ index(data.aws_availability_zones.available.names, each.value)+1}0.0/24"
  availability_zone = each.value

  tags = {
    Name = "private_subnet_${ index(data.aws_availability_zones.available.names, each.value)}"
    project = "vpc_ha"
  }
}

### Public Gateway to route internet traffic
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "internet_gw"
    project = "vpc_ha"
  }
}

# Routing table to route traffic to internet GW
resource "aws_route_table" "rtb_public" {
  vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gw.id}"
    }
  tags = {
    Name = "internet-routing"
    project = "vpc_ha"
  }
}

# Associate routing rule to public IPS
resource "aws_route_table_association" "public_route_association" {
  for_each = toset(data.aws_availability_zones.available.names)
  subnet_id      = aws_subnet.public[each.value].id
  route_table_id = aws_route_table.rtb_public.id
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
    project = "vpc_ha"
  }
}