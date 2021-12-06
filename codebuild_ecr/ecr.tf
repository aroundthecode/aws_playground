resource "aws_ecr_repository" "pathfinder" {
  name                 = "playground-pathfinder"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "pathfinder docker repository"
    project = "codebuild_ecr"
  }
}

