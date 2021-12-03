resource "aws_s3_bucket" "lambda_lifecycle_bucket" {
  bucket        = "playground-lambda-lifecycle-bucket"
  acl           = "private"
  force_destroy = true

  tags = {
    Name        = "Lifecycle lambda function bucket"
    project     = "vpc_ha"
  }
}
