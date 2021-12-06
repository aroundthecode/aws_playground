output "repo_url_http" {
  description = "Git repo clone url"
  value = aws_codecommit_repository.pathfinder.clone_url_http 
}
