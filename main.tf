resource "aws_vpc" "demo_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "demo-vpc"
  }
}
resource "aws_subnet" "public0" {
  vpc_id     = aws_vpc.demo_vpc.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "public-subnet0"
  }
}
resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.demo_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "public-subnet1"
  }
}
resource "aws_subnet" "private0" {
  vpc_id     = aws_vpc.demo_vpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "private-subnet0"
  }
}
resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.demo_vpc.id
  cidr_block = "10.0.3.0/24"
  tags = {
    Name = "private-subnet1"
  }
}

resource "aws_internet_gateway" "demo-gw" {
  vpc_id = aws_vpc.demo_vpc.id
  tags = {
    Name = "demo-gw"
  }
}
resource "aws_eip" "nat0" {
  vpc = true
  tags = {
    "Name" = "demo-nat0"
  }
}

resource "aws_eip" "nat1" {
  vpc = true
  tags = {
    "Name" = "demo-nat1"
  }
}

resource "aws_nat_gateway" "nat-gw0" {
  allocation_id = aws_eip.nat0.id
  subnet_id     = aws_subnet.public0.id
  tags = {
    "Name" = "demo-nat-gw0"
  }
}
resource "aws_nat_gateway" "nat-gw1" {
  allocation_id = aws_eip.nat1.id
  subnet_id     = aws_subnet.public1.id
  tags = {
    "Name" = "demo-nat-gw1"
  }
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.demo_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-gw.id
  }
  tags = {
    "Name" = "demo-public-rt"
  }
}
resource "aws_route_table" "private0" {
  vpc_id = aws_vpc.demo_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw0.id
  }
  tags = {
    "Name" = "demo-private0"
  }
}
resource "aws_route_table" "private1" {
  vpc_id = aws_vpc.demo_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw1.id
  }
  tags = {
    "Name" = "demo-private1"
  }
}
resource "aws_route_table_association" "public0" {
  subnet_id      = aws_subnet.public0.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "private0" {
  subnet_id      = aws_subnet.private0.id
  route_table_id = aws_route_table.private0.id
}
resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private1.id
}