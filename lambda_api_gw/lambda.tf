data "archive_file" "lambda_hello_world" {
  type = "zip"
  source_dir  = "${path.module}/lambda"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_s3_bucket_object" "lambda_hello_world" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "lambda.zip"
  source = data.archive_file.lambda_hello_world.output_path
  etag = filemd5(data.archive_file.lambda_hello_world.output_path)

  tags = {
    Name        = "Lambda function bucket object"
    project     = "lambda_api_gw"
  }
}

resource "aws_lambda_function" "hello_world" {
  function_name = "HelloWorld"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_bucket_object.lambda_hello_world.key

  runtime = "python3.6"
  handler = "lambda.lambda_handler"

  source_code_hash = data.archive_file.lambda_hello_world.output_base64sha256

  role = aws_iam_role.lambda_exec.arn

  tags = {
    Name        = "Hello World Lambda function"
    project     = "lambda_api_gw"
  }
}

resource "aws_cloudwatch_log_group" "hello_world" {
  name = "/aws/lambda/${aws_lambda_function.hello_world.function_name}"
  retention_in_days = 1
  tags = {
    Name        = "Lambda function LogGroup"
    project     = "lambda_api_gw"
  }
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_py_helloword"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })

  tags = {
    Name        = "Lambda function Role"
    project     = "lambda_api_gw"
  }
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}