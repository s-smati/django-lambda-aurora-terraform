# IAM role which dictates what other AWS services the Lambda function
 # may access.
resource "aws_iam_role" "lambda-role" {
  name = "${var.lambda-function-name}-role"

  assume_role_policy = file("policies/lambda-role.json")
}

resource "aws_iam_policy" "lambda-policy" {
  name        = "${var.lambda-function-name}-policy"

  policy = file("policies/lambda-policy.json")
}

resource "aws_iam_role_policy_attachment" "lambda-role-policy" {
  role       = aws_iam_role.lambda-role.name
  policy_arn = aws_iam_policy.lambda-policy.arn
}