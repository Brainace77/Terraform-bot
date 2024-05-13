# Create VPC
resource "aws_vpc" "brain" {
  cidr_block = "10.0.0.0/16"
  tags = {
    name = "cust-vpc"
  }
}

#Create Subnet

resource "aws_subnet" "pub-sub" {
  vpc_id     = aws_vpc.brain.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-south-1a"
}

# Create IG and attach to vpc

resource "aws_internet_gateway" "Internet-G" {
  vpc_id = aws_vpc.brain.id

}

# Create RT and Configure IG (edit routes)

resource "aws_route_table" "brain" {
  vpc_id = aws_vpc.brain.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Internet-G.id
  }
}

# Subnet Assosiation

resource "aws_route_table_association" "brain" {
  subnet_id      = aws_subnet.pub-sub.id
  route_table_id = aws_route_table.brain.id

}

#Create private Subnet

resource "aws_subnet" "pvt_subnet" {
  vpc_id     = aws_vpc.brain.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

}

# create elastic ip
resource "aws_eip" "eip" {
  domain = "vpc"

}

# create nat-gateway
resource "aws_nat_gateway" "nat" {
  subnet_id     = aws_subnet.pub-sub.id
  allocation_id = aws_eip.eip.id

  tags = {
    name = "my-nat"
  }

}

#create RT and attach to nat-gate

resource "aws_route_table" "pvt-RT" {
  vpc_id = aws_vpc.brain.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

}

# subnet assosiation  to add into pvt RT

resource "aws_route_table_association" "ass-nat" {
  route_table_id = aws_route_table.pvt-RT.id
  subnet_id      = aws_subnet.pvt_subnet.id

}

# Create Security Group

resource "aws_security_group" "brain" {
  name   = "brain"
  vpc_id = aws_vpc.brain.id
  tags = {
    name = "my-sg"
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
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

#create ec2 instance

resource "aws_instance" "pub-ec2" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.pub-sub.id
  vpc_security_group_ids      = [aws_security_group.brain.id]
  associate_public_ip_address = true


  tags = {
    Name = "New-ec2"
  }
}

#create pvt ec2 instance

resource "aws_instance" "pvt-ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = aws_subnet.pvt_subnet.id
  vpc_security_group_ids = [aws_security_group.brain.id]

  tags = {
    Name = "private-ec2"
  }

}
