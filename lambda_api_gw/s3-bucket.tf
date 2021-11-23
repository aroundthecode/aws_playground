resource "aws_s3_bucket" "lambda_bucket" {
  bucket        = "playground-python-lambda"
  acl           = "private"
  force_destroy = true

  tags = {
    Name        = "Lambda function bucket"
    project     = "lambda_api_gw"
  }
}
