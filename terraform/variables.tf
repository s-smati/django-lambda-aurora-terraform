# Region

variable "region" {
  description = "The AWS region to create resources in."
  default     = "us-east-1"
}

# Availaibility Zones
variable "mmyproject-django-dev-us-east-1-azs" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

# Subnets
variable "myproject-django-dev-pri1-subnet-a-cidr" {
  description = "CIDR Block for Private Subnet 1"
  default     = "10.0.1.0/24"
}
variable "myproject-django-dev-pri2-subnet-b-cidr" {
  description = "CIDR Block for Private Subnet 2"
  default     = "10.0.2.0/24"
}
variable "myproject-django-dev-pri3-subnet-c-cidr" {
  description = "CIDR Block for Private Subnet 3"
  default     = "10.0.3.0/24"
}

#Aurora
variable "aurora-db-name" {
  description = "RDS database name"
  default     = "mydb"
}
variable "aurora-username" {
  description = "RDS database username"
  default     = "myusername"
}
variable "aurora-password" {
  description = "RDS database password"
}


#Django App
variable "django_superuser_password" {
  description = "Django Superuser default password"
  default     = "mypassword"
}

#ECR Image link
variable "myproject-django-image-url" {
  description = "Docker image to run in the ECS cluster"
  # Be sure to repplace <AWS_ACCOUNT_ID> with your account ID
  default     = "<AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/myproject:latest"
}

#Lambda Functaion name
variable "lambda-function-name" {
  description = "Lambda function name"
  default     = "myproject-django-dev-lambda"
}

#S3 Bucket
variable "myproject-django-dev-s3-bucket-name" {

  description = "Lambda function name"
  default     = "myproject-django-dev-bucket"
}


#Stage
variable "myproject-django-dev-apigw-stage" {

  description = "Project Stage"
  default     = "dev"
}

