resource "aws_iam_role" "pathfinder_role" {
  name = "pathfinder"
  assume_role_policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
        {
            Effect: "Allow",
            Principal: {
                Service: "codebuild.amazonaws.com"
            },
            Action: "sts:AssumeRole"
        }
    ]
  })

  inline_policy {
    name = "Pathfinder-ECR"
    policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "VisualEditor0",
                "Effect": "Allow",
                "Action": [
                    "ecr:BatchGetImage",
                    "ecr:BatchCheckLayerAvailability",
                    "ecr:CompleteLayerUpload",
                    "ecr:DescribeImages",
                    "ecr:DescribeRepositories",
                    "ecr:GetDownloadUrlForLayer",
                    "ecr:InitiateLayerUpload",
                    "ecr:ListImages",
                    "ecr:PutImage",
                    "ecr:UploadLayerPart"
                ],
                "Resource": "${aws_ecr_repository.pathfinder.arn}"
            },
            {
                "Sid": "VisualEditor1",
                "Effect": "Allow",
                "Action": "ecr:GetAuthorizationToken",
                "Resource": "*"
            }
        ]
    })
  }

    inline_policy {
    name = "Pathfinder-CloudWatchLog"
    policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Resource": [
                    "arn:aws:logs:${var.aws_region}:${var.aws_account}:log-group:codebuild",
                    "arn:aws:logs:${var.aws_region}:${var.aws_account}:log-group:codebuild:*"
                ],
                "Action": [
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ]
            }
        ]
    })
    }

  inline_policy {
    name = "Pathfinder-CodeBuildBase"
    policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Resource": [
                    "arn:aws:logs:${var.aws_region}:${var.aws_account}:log-group:/aws/codebuild/Pathfinder",
                    "arn:aws:logs:${var.aws_region}:${var.aws_account}:log-group:/aws/codebuild/Pathfinder:*"
                ],
                "Action": [
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ]
            },
            {
                "Effect": "Allow",
                "Resource": [
                    "arn:aws:s3:::codepipeline-${var.aws_region}-*"
                ],
                "Action": [
                    "s3:PutObject",
                    "s3:GetObject",
                    "s3:GetObjectVersion",
                    "s3:GetBucketAcl",
                    "s3:GetBucketLocation"
                ]
            },
            {
                "Effect": "Allow",
                "Resource": [
                    "arn:aws:codecommit:${var.aws_region}:${var.aws_account}:PathFinderAWS"
                ],
                "Action": [
                    "codecommit:GitPull"
                ]
            },
            {
                "Effect": "Allow",
                "Action": [
                    "codebuild:CreateReportGroup",
                    "codebuild:CreateReport",
                    "codebuild:UpdateReport",
                    "codebuild:BatchPutTestCases",
                    "codebuild:BatchPutCodeCoverages"
                ],
                "Resource": [
                    "arn:aws:codebuild:${var.aws_region}:${var.aws_account}:report-group/Pathfinder-*"
                ]
            }
        ]
    })
  }


  tags = {
    project = "codebuild_ecr"
  }
}

# aws codebuild batch-get-projects --names Pathfinder
resource "aws_codebuild_project" "pathfinder" {
  name          = "pathfinder"
  description   = "Pathfinder codebuild project"
  build_timeout = "5"
  service_role  = aws_iam_role.pathfinder_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type = "NO_CACHE"
  }

  source {
    type            = "CODECOMMIT"
    location        = "https://git-codecommit.${var.aws_region}.amazonaws.com/v1/repos/${aws_codecommit_repository.pathfinder.repository_name}"
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = false
    }
    buildspec = file("buildspec.yaml")
  }

  source_version = aws_codecommit_repository.pathfinder.default_branch

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
  }

  logs_config{
      cloudwatch_logs{
          status        = "ENABLED"
          group_name    = "codebuild"
          stream_name   = "pathfinder"
      }
      s3_logs {
          status        = "DISABLED"
      }
  }
  
  
}
