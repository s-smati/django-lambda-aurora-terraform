# VPC
resource "aws_vpc" "myproject-django-dev-us-east-1-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "myproject-django-dev-us-east-1-vpc"
  }
}

# Private subnets
resource "aws_subnet" "myproject-django-dev-pri1-subnet-a" {
  cidr_block        = var.myproject-django-dev-pri1-subnet-a-cidr
  vpc_id            = aws_vpc.myproject-django-dev-us-east-1-vpc.id
  availability_zone = var.mmyproject-django-dev-us-east-1-azs[0]

  tags = {
    Name = "myproject-django-dev-pri1-subnet-a"
  }
}
resource "aws_subnet" "myproject-django-dev-pri2-subnet-b" {
  cidr_block        = var.myproject-django-dev-pri2-subnet-b-cidr
  vpc_id            = aws_vpc.myproject-django-dev-us-east-1-vpc.id
  availability_zone = var.mmyproject-django-dev-us-east-1-azs[1]

  tags = {
    Name = "myproject-django-dev-pri2-subnet-b"
  }
}
resource "aws_subnet" "myproject-django-dev-pri3-subnet-c" {
  cidr_block        = var.myproject-django-dev-pri3-subnet-c-cidr
  vpc_id            = aws_vpc.myproject-django-dev-us-east-1-vpc.id
  availability_zone = var.mmyproject-django-dev-us-east-1-azs[2]

  tags = {
    Name = "myproject-django-dev-pri3-subnet-c"
  }
}


# Route tables for the subnets
resource "aws_route_table" "myproject-django-dev-pri1-rtb" {
  vpc_id = aws_vpc.myproject-django-dev-us-east-1-vpc.id

  tags = {
    Name = "myproject-django-dev-pri1-rtb"
  }
}

# Associate the newly created route tables to the subnets
resource "aws_route_table_association" "myproject-django-dev-pri1-rtb-ass1" {
  route_table_id = aws_route_table.myproject-django-dev-pri1-rtb.id
  subnet_id      = aws_subnet.myproject-django-dev-pri1-subnet-a.id
}
resource "aws_route_table_association" "myproject-django-dev-pri1-rtb-ass2" {
  route_table_id = aws_route_table.myproject-django-dev-pri1-rtb.id
  subnet_id      = aws_subnet.myproject-django-dev-pri2-subnet-b.id
}
resource "aws_route_table_association" "myproject-django-dev-pri1-rtb-ass3" {
  route_table_id = aws_route_table.myproject-django-dev-pri1-rtb.id
  subnet_id      = aws_subnet.myproject-django-dev-pri3-subnet-c.id
}


# Create VPC S3 Gateway EndPoint

resource "aws_vpc_endpoint" "myproject-django-dev-endpoint-s3" {
  vpc_id       = aws_vpc.myproject-django-dev-us-east-1-vpc.id
  vpc_endpoint_type = "Gateway"
  service_name = "com.amazonaws.us-east-1.s3"
  route_table_ids = [aws_route_table.myproject-django-dev-pri1-rtb.id]

  tags = {
    Environment = "myproject-django-dev-endpoint-s3"
  }
}

