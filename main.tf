provider "aws" {
  region = "ap-northeast-1"
}

# 1.create your vpc

resource "aws_vpc" "ironman" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "name" = "ironman"
  }
}


# 2. create a public subnet
resource "aws_subnet" "PublicSubnet" {
  vpc_id            = aws_vpc.ironman.id
  availability_zone = "ap-northeast-1a"
  cidr_block        = "10.0.1.0/24"
}


# 3.create a private subnet

resource "aws_subnet" "PrivateSubnet" {
  vpc_id                  = aws_vpc.ironman.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
}

# 4. Create an IGW

resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.ironman.id
}

# 5. Route tables for public subnet

resource "aws_route_table" "publicRT" {
  vpc_id = aws_vpc.ironman.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myigw.id
  }
}

# 6. route table associtation with public subnet

resource "aws_route_table_association" "PublicRouteTableAssociation" {
  subnet_id = aws_subnet.PublicSubnet.id
  route_table_id = aws_route_table.publicRT.id
  
}
