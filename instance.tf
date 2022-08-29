data "aws_key_pair" "webserver-key" {
  key_name = "vpro-key"
}

data "aws_ami" "amazonlinux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"]
}

resource "aws_instance" "app-server" {
  ami                    = data.aws_ami.amazonlinux.id
  associate_public_ip_address = true
  instance_type          = var.instance_type
  key_name               = data.aws_key_pair.webserver-key.key_name
  vpc_security_group_ids = [aws_security_group.my-app-sg.id]
  subnet_id = aws_subnet.public[1].id

  user_data = <<EOF
#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd && systemctl enable httpd
EOF

  tags = {
    "Name" = "webserver"
  }
}

resource "aws_security_group" "my-app-sg" {
  vpc_id = aws_vpc.demo-vpc.id

  ingress {
    description = "allow ssh connectivity"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    description = "allow public connectivity"
    from_port   = 80
    to_port     = 80
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
