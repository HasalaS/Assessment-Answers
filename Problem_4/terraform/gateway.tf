resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.elb_public_1.id
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip" "nat_eip" {
  enable = true
}

