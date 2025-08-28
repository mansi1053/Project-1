locals {
 aws_user_data = file("${path.module}/userdata/aws.sh")
}

resource "aws_instance" "example1" {
  ami = var.aws_ami.id
  instance_type = var.aws_instance_type
  user_data     = file("${path.module}/../scripts/install_nginx.sh")
  subnet_id = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.sg1.id]
  
  tags = {
    Name = "ExampleInstance"
  }
}

resource "aws_vpc" "vpc1" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "vpc1"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = var.subnet_cidr_block[0]
  tags = {
    Name = "subnet1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = var.subnet_cidr_block[1]
  tags = {
    Name = "subnet2"
  }
}

resource "aws_subnet" "subnet3" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = var.subnet_cidr_block[2]
  tags = {
    Name = "subnet3"
  }
}

resource "aws_security_group" "sg1" {
  name        = "sg1"
  description = "Security group for example instances"
  vpc_id      = aws_vpc.vpc1.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}