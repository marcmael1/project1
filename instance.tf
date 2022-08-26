resource "aws_instance" "my-app" {
  ami           = "ami-052efd3df9dad4825"
  instance_type = "t2.micro"
  key_name      = "vpro-key"

  tags = {
    "Name" = "webserver"
  }
}

resource "aws_security_group" "my-app-sg" {
  vpc_id = aws_vpc.demo-vpc.id

  ingress {
    description      = "allow incoming traffic"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "allow traffic"
  }
}
