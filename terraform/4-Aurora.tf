# DB Subnet Group
resource "aws_db_subnet_group" "myproject-django-dev-aurora-subnet-group" {
  name       = "myproject-django-dev-aurora-subnet-group"
  subnet_ids = [aws_subnet.myproject-django-dev-pri1-subnet-a.id, aws_subnet.myproject-django-dev-pri2-subnet-b.id, aws_subnet.myproject-django-dev-pri3-subnet-c.id]
}

#Aurora cluster
resource "aws_rds_cluster" "myproject-django-dev-aurora-cluster" {
  cluster_identifier      = "myproject-django-dev-aurora-cluster"
  engine                  = "aurora-postgresql"
  engine_mode             = "serverless"
  engine_version          = "10.12"
  availability_zones      = var.mmyproject-django-dev-us-east-1-azs
  database_name           = var.aurora-db-name
  master_username         = var.aurora-username
  master_password         = var.aurora-password
  port                    = "5432"
  backup_retention_period = 7
  preferred_backup_window = "07:00-09:00"
  db_subnet_group_name    = aws_db_subnet_group.myproject-django-dev-aurora-subnet-group.name
  vpc_security_group_ids  = [aws_security_group.myproject-django-dev-aurora-sg.id]
  skip_final_snapshot  = true

  scaling_configuration {
    auto_pause               = true
    min_capacity             = 2
    max_capacity             = 2
    seconds_until_auto_pause = 300
    timeout_action           = "ForceApplyCapacityChange"
  }
}