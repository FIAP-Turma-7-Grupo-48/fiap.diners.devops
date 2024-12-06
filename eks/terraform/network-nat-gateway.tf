
resource "aws_eip" "nat" {
  tags = {
    Name = "nat"
  }
}

resource "aws_nat_gateway" "nat-fiap-soat-t7-g48" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public-sa-east-1a.id

  tags = {
    Name = "nat-fiap-soat-t7-g48"
  }

  depends_on = [aws_internet_gateway.igw-fiap-soat-t7-g48]
}