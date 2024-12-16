# private subnet 01

resource "aws_subnet" "private-sa-east-1a" {
  vpc_id            = aws_vpc.vpc-fiap-soat-t7-g48.id
  cidr_block        = "192.168.0.0/19"
  availability_zone = "sa-east-1a"

  tags = {
    Name                              = "private-sa-east-1a"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/fiap-soat-t7-g48"      = "owned"
  }
}
# private subnet 02

resource "aws_subnet" "private-sa-east-1b" {
  vpc_id            = aws_vpc.vpc-fiap-soat-t7-g48.id
  cidr_block        = "192.168.32.0/19"
  availability_zone = "sa-east-1b"

  tags = {
    Name                              = "private-sa-east-1b"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/fiap-soat-t7-g48"      = "owned"
  }
}

# public subnet 01

resource "aws_subnet" "public-sa-east-1a" {
  vpc_id                  = aws_vpc.vpc-fiap-soat-t7-g48.id
  cidr_block              = "192.168.64.0/19"
  availability_zone       = "sa-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name                         = "public-sa-east-1a"
    "kubernetes.io/role/elb"     = "1" #this instruct the kubernetes to create public load balancer in these subnets
    "kubernetes.io/cluster/fiap-soat-t7-g48" = "owned"
  }
}
# public subnet 02

resource "aws_subnet" "public-sa-east-1b" {
  vpc_id                  = aws_vpc.vpc-fiap-soat-t7-g48.id
  cidr_block              = "192.168.96.0/19"
  availability_zone       = "sa-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name                         = "public-sa-east-1b"
    "kubernetes.io/role/elb"     = "1" #this instruct the kubernetes to create public load balancer in these subnets
    "kubernetes.io/cluster/fiap-soat-t7-g48" = "owned"
  }
}