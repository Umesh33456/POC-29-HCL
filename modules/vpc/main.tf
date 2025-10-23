########################################
# Create VPC
########################################
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

########################################
# Create Internet Gateway
########################################
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

########################################
# Get Availability Zones
########################################
data "aws_availability_zones" "available_zones" {}

########################################
# Create Public Subnet
########################################
resource "aws_subnet" "pub_sub_1a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pub_sub_1a_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "public_sub"
  }
}

########################################
# Create Route Table for Public Subnet
########################################
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "Public-rt"
  }
}

# Associate Public Subnet with Public Route Table
resource "aws_route_table_association" "pub_sub_1a_association" {
  subnet_id      = aws_subnet.pub_sub_1a.id
  route_table_id = aws_route_table.public_route_table.id
}

########################################
# Allocate Elastic IP for NAT Gateway
########################################
resource "aws_eip" "nat" {

  tags = {
    Name = "${var.project_name}-nat-eip"
  }
}

########################################
# Create NAT Gateway in Public Subnet
########################################
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.pub_sub_1a.id

  tags = {
    Name = "${var.project_name}-nat-gateway"
  }
}

########################################
# Create Private Subnet
########################################
resource "aws_subnet" "pri_sub_3a" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.pri_sub_3a_cidr
  availability_zone        = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch  = false

  tags = {
    Name = "private_sub"
  }
}

########################################
# Get Default (Main) Route Table
########################################
data "aws_route_table" "main" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.vpc.id]
  }

  filter {
    name   = "association.main"
    values = ["true"]
  }
}

########################################
# Add NAT Gateway route to Default Route Table
########################################
resource "aws_route" "private_nat_route" {
  route_table_id         = data.aws_route_table.main.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

########################################
# Explicitly Associate Private Subnet to Default Route Table (optional)
########################################
resource "aws_route_table_association" "pri_sub_3a_main" {
  subnet_id      = aws_subnet.pri_sub_3a.id
  route_table_id = data.aws_route_table.main.id
}
