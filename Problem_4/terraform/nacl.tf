resource "aws_network_acl" "ec2_private_nacl" {
  vpc_id = aws_vpc.main.id
}

resource "aws_network_acl" "elb_public_nacl" {
  vpc_id = aws_vpc.main.id
}