resource "aws_route_table" "ec2_private_rt1" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "10.0.10.0/24"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "ec2_private_rt2" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "10.0.11.0/24"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "elb_public_rt1" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "10.0.20.0/24"
    gateway_id = aws_internet_gateway.nat.id
  }
}

resource "aws_route_table" "elb_public_rt2" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "10.0.21.0/24"
    gateway_id = aws_internet_gateway.nat.id
  }
}
