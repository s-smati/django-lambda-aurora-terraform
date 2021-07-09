#S3 Bucket
resource "aws_s3_bucket" "myproject-django-dev-s3-bucket" {

  bucket = var.myproject-django-dev-s3-bucket-name

  acl    = "public-read"

  force_destroy = true

  tags = {
    Name        = var.myproject-django-dev-s3-bucket-name
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_policy" "myproject-django-dev-s3-bucket-policy" {
  bucket = aws_s3_bucket.myproject-django-dev-s3-bucket.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression's result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "MYBUCKETPOLICY"
    Statement = [
      {
        Sid       = "Access-to-specific-VPCE-only"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.myproject-django-dev-s3-bucket.arn,
          "${aws_s3_bucket.myproject-django-dev-s3-bucket.arn}/*",
        ]
        Condition = {
          StringEquals = {
            "aws:sourceVpce" = aws_vpc_endpoint.myproject-django-dev-endpoint-s3.id
          }
        }
      },
      {
        Sid = "Make-bucket-public",
        Effect = "Allow",
        Principal = "*",
        Action = ["s3:GetObject"],
        Resource = [
          aws_s3_bucket.myproject-django-dev-s3-bucket.arn,
          "${aws_s3_bucket.myproject-django-dev-s3-bucket.arn}/*",
        ]
      }
    ]
  })
}