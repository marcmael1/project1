
locals {
  public_cidr  = ["10.0.0.0/24", "10.0.1.0/24"]
  private_cidr = ["10.0.2.0/24", "10.0.3.0/24"]
}

resource "aws_vpc" "demo-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = var.env_code
  }
}

resource "aws_subnet" "public" {

  count = length(local.public_cidr)

  vpc_id     = aws_vpc.demo-vpc.id
  cidr_block = local.public_cidr[count.index]

  tags = {
    Name = "${var.env_code}-public-subnet${count.index}"
  }
}

resource "aws_subnet" "private" {

  count = length(local.private_cidr)

  vpc_id     = aws_vpc.demo-vpc.id
  cidr_block = local.private_cidr[count.index]

  tags = {
    Name = "${var.env_code}-private-subnet${count.index}"
  }
}

resource "aws_internet_gateway" "demo-gw" {
  vpc_id = aws_vpc.demo-vpc.id

  tags = {
    Name = var.env_code
  }
}

resource "aws_eip" "nat" {
  count = length(var.public_cidr)

  vpc = true

  tags = {
    "Name" = "${var.env_code}-demo-nat${count.index}"
  }
}

resource "aws_nat_gateway" "nat-gw" {
  count = length(var.public_cidr)

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    "Name" = "${var.env_code}-demo-nat-gw${count.index}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.demo-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-gw.id
  }

  tags = {
    "Name" = "${var.env_code}-demo-public-rt"
  }
}

resource "aws_route_table" "private" {
  count = length(var.private_cidr)

  vpc_id = aws_vpc.demo-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw[count.index].id
  }

  tags = {
    "Name" = "${var.env_code}-demo-private${count.index}"
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.public_cidr)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_cidr)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
