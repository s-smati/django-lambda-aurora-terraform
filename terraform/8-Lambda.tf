
resource "aws_lambda_function" "myproject-django-dev-lambda-function" {
   function_name = var.lambda-function-name

   # The bucket name as created earlier with "aws s3api create-bucket"
   package_type = "Image"
   image_uri = var.myproject-django-image-url
   runtime = "python3.8"

   role = aws_iam_role.lambda-role.arn

   timeout = 900
   vpc_config {
      subnet_ids = [aws_subnet.myproject-django-dev-pri1-subnet-a.id, aws_subnet.myproject-django-dev-pri2-subnet-b.id, aws_subnet.myproject-django-dev-pri3-subnet-c.id]
      security_group_ids = [aws_security_group.myproject-django-dev-lambda-sg.id]
   }

   environment {
      variables = {
         AURORA_DB_NAME = var.aurora-db-name
         AURORA_USERNAME = var.aurora-username
         AURORA_PASSWORD = var.aurora-password
         AURORA_HOSTNAME = aws_rds_cluster.myproject-django-dev-aurora-cluster.endpoint
         AURORA_PORT = "5432"
         AWS_STORAGE_BUCKET_NAME = var.myproject-django-dev-s3-bucket-name
         DJANGO_SUPERUSER_PASSWORD = var.django_superuser_password
      }
   } 

   depends_on = [
      aws_iam_role_policy_attachment.lambda-role-policy,
      aws_cloudwatch_log_group.lambda-cloudwatch,
  ]
}