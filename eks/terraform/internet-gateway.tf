resource "aws_internet_gateway" "igw-fiap-soat-t7-g48" {
  vpc_id = aws_vpc.vpc-fiap-soat-t7-g48.id

  tags = {
    Name = "igw-vpc-fiap-soat-t7-g48"
  }
}