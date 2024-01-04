resource "aws_vpc" "myvpc" {
  cidr_block                       = "10.1.0.0/16"
  instance_tenancy                 = "default"
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true
  tags = {
    Name = "TerraformVPC"
  }
}

resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "TerraformIGW"
  }

}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.1.1.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "TerraformPublicSubnet"
  }
}

resource "aws_route_table" "mypubrt" {
  vpc_id = aws_vpc.myvpc.id

  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.myigw.id}"
  }

  tags = {
    Name = "TerraformPublicRT"
  }
}

resource "aws_route_table_association" "public-subnet-route-table-association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.mypubrt.id
}

resource "aws_subnet" "private_subnet" {
  vpc_id                          = aws_vpc.myvpc.id
  cidr_block                      = "10.1.2.0/24"
  availability_zone               = "ap-northeast-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "TerraformPrivateSubnet"
  }
}