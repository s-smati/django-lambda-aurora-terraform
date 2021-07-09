resource "aws_cloudwatch_log_group" "lambda-cloudwatch" {
  name              = "/aws/myproject/dev/lambda/${var.lambda-function-name}"
  retention_in_days = 7
}
