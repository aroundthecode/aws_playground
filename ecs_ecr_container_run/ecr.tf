
# resource "aws_kms_key" "docker_crypt_key" {
#   description                   = "ECR Key"
#   deletion_window_in_days       = 7
#   key_usage                     = "ENCRYPT_DECRYPT"
#   customer_master_key_spec      = "SYMMETRIC_DEFAULT"
#   tags = {
#     Name        = "Key for ECS repository"
#     project = "ecs_ecr_container_run"
#   }
# }



resource "aws_ecr_repository" "playground" {
  name                 = "playground"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
#   encryption_configuration{
#     encryption_type   = "KMS"
#     kms_key           = aws_kms_key.docker_crypt_key.arn 
#   }
  

  tags = {
    Name        = "Test docker repository"
    project = "ecs_ecr_container_run"
  }
}

resource "aws_iam_role" "docker_role" {
  name = "ecr_access"
  assume_role_policy = file("role.json")

  inline_policy {
    name = "ecr_access"
    policy = templatefile("ecr_policy.json",
      { 
        repo_acr= aws_ecr_repository.playground.arn
      }
    )
  }
  tags = {
    project = "ecs_ecr_container_run"
  }
}