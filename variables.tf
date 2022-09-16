
# Provider
variable "region-name" {
description = "name of region"
default = "eu-west-2"
type = string
}


# VPC

variable "cidre-for-vpc" {
description = "the cidre for vpc"
default = "10.0.0.0/16"
type = string

}

# Private Subnets

variable "cidre-for-test-priv-sub-1" {
description = "name for private subnet 1 "
default = "10.0.1.0/24"
type = string
} 

variable "cidre-for-test-priv-sub-2" {
description = "name for private subnet 2 "
default = "10.0.2.0/24"
type = string
} 

# Public Subnets

variable "cidre-for-test-public-sub-1" {
description = "name for public subnet 1 "
default = "10.0.3.0/24"
type = string
} 

variable "cidre-for-test-public-sub-2" {
description = "name for public subnet 2 "
default = "10.0.4.0/24"
type = string
} 

# Private Route Table

variable "name-for-private-route-table" {
description = "name for private route table "
default = "test-priv-route-table"
type = string
} 

# Public Route Table

variable "name-for-public-route-table" {
description = "name for public route table"
default = "test-pub-route-table"
type = string
} 

# Internet Gateway

variable "name-for-internet-gateway" {
description = "name for internet gateway"
default = "test-igw"
type = string
} 

# Route

variable "cidre-for-route" {
description = "cidre for route"
default = "0.0.0.0/0"
type = string
} 

# test nat associations

variable "test-nat-association-connectivity-type" {
description = "connectivity type"
default = "private"
type = string
} 


variable "test-nat-association-1-connectivity-type" {
description = "connectivity type"
default = "private"
type = string
} 

# EC2 (Ubuntu 18.04 Public)

variable "name-for-instance" {
description = "instance name"
default = "test=server-1"
type = string
}

variable "ami" {
description = "type of ami"
default = "ami-05a8c865b4de3b127"
type = string
}

variable "instance-type" {
description = "instance type"
default = "t2.micro"
type = string
}
  
variable "key-name" {
description = "key name"
default = "Derek-KP"
type = string
  
}

variable "availability_zone" {
description = "availability zone"
default = "eu-west-2b"
type = string
  
}

# EC2 (Ubuntu 18.04 Private)

variable "name-for-instance-1" {
description = "instance name"
default = "test=server-2"
type = string
}

variable "ami-1" {
description = "type of ami"
default = "ami-05a8c865b4de3b127"
type = string
}

variable "instance-type-1" {
description = "instance type"
default = "t2.micro"
type = string
}
  
variable "key-name_1" {
description = "key name"
default = "Ans-KP"
type = string
  
}

variable "availability_zone_1" {
description = "availability zone"
default = "eu-west-2b"
type = string
  
}

