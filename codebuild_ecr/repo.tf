resource "aws_codecommit_repository" "pathfinder" {
  repository_name   = "pathfinder"
  description       = "Pathfinder AWS repository"
  default_branch    = "master"
  tags = {
    Name            = "pathfinder"
    project         = "codebuild_ecr"
  }
}