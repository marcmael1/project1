data "aws_key_pair" "webserver-key" {
  key_name = "vpro-key"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["self"]
  tags = {
    Name   = "app-server"
    Tested = "true"
  }
}

resource "aws_instance" "app-server" {
  ami           = data.aws_ami.ubuntu
  instance_type = var.instance_type
  key_name      = data.aws_key_pair.webserver-key.key_name
  tags = {
    "Name" = "webserver"
  }
}

resource "aws_security_group" "my-app-sg" {
  vpc_id = aws_vpc.demo-vpc.id

  ingress {
    description = "allow incoming traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "allow traffic"
  }
}
