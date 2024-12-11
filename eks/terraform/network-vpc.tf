# Create a VPC
resource "aws_vpc" "vpc-fiap-soat-t7-g48" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "vpc-fiap-soat-t7-g48"
  }
}