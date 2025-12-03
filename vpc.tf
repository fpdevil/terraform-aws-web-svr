# Resource: VPC
# VPC is  a logically  isolated section  of AWS  where resources  can be
# launched in a  virtual network. It acts as the  foundational layer for
# all  cloud  infrastructure, providing  control  over  your IP  address
# range, subnets, routing, and security.
# Calculate VPC CIDR using https://visualsubnetcalc.com/
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "WebVPC"
  }
}

# Resource: Public Subnet with VPC
# Divide into required subnets as per the CIDR range defined for VPC
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.availability_zone

  # this ensures that instances launched in this subnet automatically
  # receive a public IP address
  map_public_ip_on_launch = true

  tags = {
    Name = "WebPublicSubnet"
  }
}

# Resource: Route Table
# This step creates a Route Table that essentially determines where
# the network traffic flows from and within the VPC
resource "aws_route_table" "webserver_route_table" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "WebServerRouteTable"
  }
}

# Resource: Route Table Association
# Now associate the Route Table with the Subnet created
resource "aws_route_table_association" "webserer_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.webserver_route_table.id
}

# Resource: Internet Gateway
# This is to allow communication between VPC and internet and also to connect to
# EC2 instance directly using SSH/TCP from local machine. It is the VPC's main 
# entrance point to the public world and without an IGW, no instance even if it
# has a public IP can access the internet.
#
# STEPS
# 1. Create an Internet Gateway
# 2. Attach It to Your VPC
# 3. Update Route Tables
# 4. Assign Public IPs
resource "aws_internet_gateway" "webserver_igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "WebServerInternetGateway"
  }
}

# Resource: Route in the route table
# This will be an entry in the route table with a destination IP/CIDR
# and what target to use
resource "aws_route" "webserver_internet_route" {
  destination_cidr_block = "0.0.0.0/0" # enable access to the internet
  route_table_id         = aws_route_table.webserver_route_table.id
  gateway_id             = aws_internet_gateway.webserver_igw.id
}
