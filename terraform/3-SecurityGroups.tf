# Aurora Security Group (traffic Lambda -> Aurora)
resource "aws_security_group" "myproject-django-dev-aurora-sg" {
  name        = "myproject-django-dev-aurora-sg"
  description = "Allows inbound access from Lambda only"
  vpc_id      = aws_vpc.myproject-django-dev-us-east-1-vpc.id

  ingress {
    protocol        = "tcp"
    from_port       = "5432"
    to_port         = "5432"
    security_groups = [aws_security_group.myproject-django-dev-lambda-sg.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "myproject-django-dev-aurora-sg"
  }
}

# Aurora Security Group (traffic Lambda -> Aurora)
resource "aws_security_group" "myproject-django-dev-lambda-sg" {
  name        = "myproject-django-dev-lambda-sg"
  description = "Allows inbound access to aurora"
  vpc_id      = aws_vpc.myproject-django-dev-us-east-1-vpc.id

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "myproject-django-dev-lambda-sg"
  }
}