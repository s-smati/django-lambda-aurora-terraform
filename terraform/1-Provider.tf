provider "aws" {
  region = var.region
  # Be sure to replace ACCESS_KEY_ID and SECRET_KEY_ID with your AWS credentials.
  access_key = "<ACCESS_KEY_ID>"
  secret_key = "<SECRET_KEY_ID>"
}