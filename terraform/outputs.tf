# API Gateway link to our application
output "apigateway-url" {
  value = aws_api_gateway_stage.myproject-django-apigw-stage.invoke_url
}