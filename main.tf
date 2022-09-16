# VPC
resource "aws_vpc" "prod-rock-vpc" {
  cidr_block       = var.cidre-for-vpc
  enable_dns_hostnames = "true"
  instance_tenancy = "default"

  tags = {
    Name = "prod-rock-vpc"
  }
}

# Private Subnets

resource "aws_subnet" "test-priv-sub-1" {
  vpc_id     = aws_vpc.prod-rock-vpc.id
  cidr_block = var.cidre-for-test-priv-sub-1

  tags = {
    Name = "test-priv-sub-1"
  }
}

resource "aws_subnet" "test-priv-sub-2" {
  vpc_id     = aws_vpc.prod-rock-vpc.id
  cidr_block = var.cidre-for-test-priv-sub-2

  tags = {
    Name = "test-priv-sub-2"
  }
}

# Public Subnets

resource "aws_subnet" "test-public-sub-1" {
  vpc_id     = aws_vpc.prod-rock-vpc.id
  cidr_block = var.cidre-for-test-public-sub-1

  tags = {
    Name = "test-public-sub-1"
  }
}

resource "aws_subnet" "test-public-sub-2" {
  vpc_id     = aws_vpc.prod-rock-vpc.id
  cidr_block = var.cidre-for-test-public-sub-2

  tags = {
    Name = "test-public-sub-2"
  }
}

# Private Route Table

resource "aws_route_table" "test-priv-route-table" {
  vpc_id = aws_vpc.prod-rock-vpc.id

  tags = {
    Name = var.name-for-private-route-table
  }
}

# Public Route Table

resource "aws_route_table" "test-pub-route-table" {
  vpc_id = aws_vpc.prod-rock-vpc.id

  tags = {
    Name = var.name-for-public-route-table
  }
}

# Public Sunbet 1 Association With Route Table

resource "aws_route_table_association" "test-public-route-table-association-1" {
  subnet_id      = aws_subnet.test-public-sub-1.id
  route_table_id = aws_route_table.test-pub-route-table.id
}

# Public Sunbet 2 Association With Route Table

resource "aws_route_table_association" "test-public-route-table-association-2" {
  subnet_id      = aws_subnet.test-public-sub-2.id
  route_table_id = aws_route_table.test-pub-route-table.id
}

# Private Sunbet 1 Association With Route Table

resource "aws_route_table_association" "test-private-route-table-association-1" {
  subnet_id      = aws_subnet.test-priv-sub-1.id
  route_table_id = aws_route_table.test-priv-route-table.id
}

# Private Sunbet 2 Association With Route Table

resource "aws_route_table_association" "test-private-route-table-association-2" {
  subnet_id      = aws_subnet.test-priv-sub-2.id
  route_table_id = aws_route_table.test-priv-route-table.id
}

# Internet Gateway

resource "aws_internet_gateway" "test-igw" {
  vpc_id = aws_vpc.prod-rock-vpc.id

  tags = {
    Name = var.name-for-internet-gateway
  }
}

# Route

resource "aws_route" "test-igw-association" {
  route_table_id            = aws_route_table.test-pub-route-table.id
  gateway_id                = aws_internet_gateway.test-igw.id
  destination_cidr_block    = var.cidre-for-route
}

# Nat Gateway

# test nat association

resource "aws_nat_gateway" "test-nat-association" {
  connectivity_type = var.test-nat-association-connectivity-type
  subnet_id         = aws_subnet.test-priv-sub-1.id
}

resource "aws_nat_gateway" "test-nat-association-1" {
  connectivity_type = var.test-nat-association-1-connectivity-type
  subnet_id         = aws_subnet.test-priv-sub-2.id
}

# Security Groups (test-sec-group)

resource "aws_security_group" "test-sec-group" {
  name        = "security group using terraform"
  description = "security group using terraform"
  vpc_id      = aws_vpc.prod-rock-vpc.id

 ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

   ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

   egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "tec-sec-group"
  }
}


# EC2 (Ubuntu 18.04 Public)

resource "aws_instance" "test-server-1" {
  ami           = var.ami
  instance_type = var.instance-type
  count = 1
  key_name = var.key-name
  availability_zone = var.availability_zone
  vpc_security_group_ids = [aws_security_group.test-sec-group.id]
  subnet_id   = aws_subnet.test-public-sub-1.id
  associate_public_ip_address = "true"


  tags = {
  Name = var.name-for-instance
  }
  }

# EC2 (Ubuntu 18.04 Public)

resource "aws_instance" "test-server-2" {
  ami           = var.ami-1
  instance_type = var.instance-type-1
  count = 1
  key_name = var.key-name_1
  availability_zone = var.availability_zone_1
  vpc_security_group_ids = [aws_security_group.test-sec-group.id]
  subnet_id   = aws_subnet.test-public-sub-1.id
  associate_public_ip_address = "true"

  tags = {
  Name = var.name-for-instance-1
}
  }
