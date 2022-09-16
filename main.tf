# VPC
resource "aws_vpc" "prod-rock-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "prod-rock-vpc"
  }
}

# Private Subnets

resource "aws_subnet" "test-priv-sub-1" {
  vpc_id     = aws_vpc.prod-rock-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "test-priv-sub-1"
  }
}

resource "aws_subnet" "test-priv-sub-2" {
  vpc_id     = aws_vpc.prod-rock-vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "test-priv-sub-2"
  }
}

# Public Subnets

resource "aws_subnet" "test-public-sub-1" {
  vpc_id     = aws_vpc.prod-rock-vpc.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "test-public-sub-1"
  }
}

resource "aws_subnet" "test-public-sub-2" {
  vpc_id     = aws_vpc.prod-rock-vpc.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "test-public-sub-2"
  }
}

# Private Route Table

resource "aws_route_table" "test-priv-route-table" {
  vpc_id = aws_vpc.prod-rock-vpc.id

  tags = {
    Name = "test-priv-route-table"
  }
}

# Public Route Table

resource "aws_route_table" "test-pub-route-table" {
  vpc_id = aws_vpc.prod-rock-vpc.id

  tags = {
    Name = "test-pub-route-table"
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
    Name = "test-igw"
  }
}

# Route

resource "aws_route" "test-igw-association" {
  route_table_id            = aws_route_table.test-pub-route-table.id
  gateway_id                = aws_internet_gateway.test-igw.id
  destination_cidr_block    = "0.0.0.0/0"
}

# Nat Gateway

# test nat association

resource "aws_nat_gateway" "test-nat-association" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.test-priv-sub-1.id
}

resource "aws_nat_gateway" "test-nat-association-1" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.test-priv-sub-2.id
}

# Security Groups (test-sec-group)

resource "aws_security_group" "test-sec-group" {
  name        = "security group using terraform"
  description = "security group using terraform"
  vpc_id      = aws_vpc.prod-rock-vpc.id


 ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

   ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "test-sec-group"
  }
}

# EC2 (Ubuntu 18.04 Public)

resource "aws_instance" "test-server-1" {
  ami           = "ami-05a8c865b4de3b127"
  instance_type = "t2.micro"
  count = 1
  aws_security_groups = aws_security_groups.test-sec-group.id
  key_name = "Derek-KP"
  availability_zone = "eu-west-2b"
  subnet_id   = aws_subnet.test-public-sub-1.id
  associate_public_ip_address = "true"


  tags = {
  Name = "test-server-1"
  }
  }

# EC2 (Ubuntu 18.04 Private)

resource "aws_instance" "test-server-2" {
  ami           = "ami-05a8c865b4de3b127"
  instance_type = "t2.micro"
  count = 1
  aws_security_group = aws_security_group.test-sec-group.id
  key_name = "Ans-KP"
  availability_zone = "eu-west-2b"
  subnet_id   = aws_subnet.test-priv-sub-1.id
  associate_public_ip_address = "true"

  tags = {
  Name = "test-server-2"
}
  }
