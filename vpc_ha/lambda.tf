data "archive_file" "lambda_elastic" {
  type = "zip"
  source_dir  = "${path.module}/lambda"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_s3_bucket_object" "lambda_elastic" {
  bucket = aws_s3_bucket.lambda_lifecycle_bucket.id

  key    = "lambda.zip"
  source = data.archive_file.lambda_elastic.output_path
  etag = filemd5(data.archive_file.lambda_elastic.output_path)

  tags = {
    Name        = "Lambda function bucket object"
    project     = "vpc_ha"
  }
}

resource "aws_lambda_function" "elastic" {
  function_name = "ReassignElasticIp"

  s3_bucket = aws_s3_bucket.lambda_lifecycle_bucket.id
  s3_key    = aws_s3_bucket_object.lambda_elastic.key

  runtime = "python3.6"
  handler = "reassign_eip.lambda_handler"

  source_code_hash = data.archive_file.lambda_elastic.output_base64sha256

  role = aws_iam_role.lifecycle_role.arn

  tags = {
    Name        = "Reassign EIP Lambda function"
    project     = "vpc_ha"
  }
}

resource "aws_cloudwatch_log_group" "elastic" {
  name = "/aws/lambda/${aws_lambda_function.elastic.function_name}"
  retention_in_days = 1
  tags = {
    Name        = "Lambda function LogGroup"
    project     = "vpc_ha"
  }
}

resource "aws_iam_role" "lifecycle_role" {
  name = "lifecycle_lambda_exec"

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
  
   inline_policy {
    name = "AutoScalingEvent-policy"
    policy = jsonencode(
      {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "autoscaling:CompleteLifecycleAction"
          ],
          "Resource": "${aws_autoscaling_group.autoscale_single.arn}"
        }
      ]
    })
  }
  
  inline_policy {
    name = "AssociateEIP-policy"
    policy = jsonencode(
      {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": [
                "ec2:DescribeAddresses",
                "ec2:AllocateAddress",
                "ec2:DescribeInstances",
                "ec2:AssociateAddress"
            ],
          "Resource": "*"
        }
      ]
    })
  }

  managed_policy_arns = [ 
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole" ,
    "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
    ]

  tags = {
    project = "vpc_ha"
  }
}
