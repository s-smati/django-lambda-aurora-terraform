resource "aws_api_gateway_rest_api" "myproject-django-dev-apigw-restapi" {
  name        = "myproject-django-dev-service"
  description = "Terraform Serverless Application myproject-django"
}

resource "aws_lambda_permission" "lambda-permission" {
  statement_id  = "myproject-django-dev-service-${var.lambda-function-name}-InvokeFunction"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.myproject-django-dev-lambda-function.function_name
  principal     = "apigateway.amazonaws.com"

  # The /*/*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.myproject-django-dev-apigw-restapi.execution_arn}/*/*/*"
}

resource "aws_api_gateway_resource" "proxy" {
   rest_api_id = aws_api_gateway_rest_api.myproject-django-dev-apigw-restapi.id
   parent_id   = aws_api_gateway_rest_api.myproject-django-dev-apigw-restapi.root_resource_id
   path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
   rest_api_id   = aws_api_gateway_rest_api.myproject-django-dev-apigw-restapi.id
   resource_id   = aws_api_gateway_resource.proxy.id
   http_method   = "ANY"
   authorization = "NONE"
}


resource "aws_api_gateway_integration" "myproject-django-apigw-integration" {
   rest_api_id = aws_api_gateway_rest_api.myproject-django-dev-apigw-restapi.id
   resource_id = aws_api_gateway_method.proxy.resource_id
   http_method = aws_api_gateway_method.proxy.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.myproject-django-dev-lambda-function.invoke_arn
}

resource "aws_api_gateway_method" "proxy_root" {
   rest_api_id   = aws_api_gateway_rest_api.myproject-django-dev-apigw-restapi.id
   resource_id   = aws_api_gateway_rest_api.myproject-django-dev-apigw-restapi.root_resource_id
   http_method   = "ANY"
   authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_root" {
   rest_api_id = aws_api_gateway_rest_api.myproject-django-dev-apigw-restapi.id
   resource_id = aws_api_gateway_method.proxy_root.resource_id
   http_method = aws_api_gateway_method.proxy_root.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.myproject-django-dev-lambda-function.invoke_arn
}


resource "aws_api_gateway_deployment" "myproject-django-api-gateway-deployment" {

  depends_on = [
     aws_api_gateway_integration.myproject-django-apigw-integration,
     aws_api_gateway_integration.lambda_root,
   ]

   rest_api_id = aws_api_gateway_rest_api.myproject-django-dev-apigw-restapi.id
  
}

resource "aws_api_gateway_stage" "myproject-django-apigw-stage" {

  deployment_id = aws_api_gateway_deployment.myproject-django-api-gateway-deployment.id
  rest_api_id   = aws_api_gateway_rest_api.myproject-django-dev-apigw-restapi.id
  stage_name  = var.myproject-django-dev-apigw-stage

}

