resource "aws_ecr_repository" "churn_repo" {
  name                 = "churn-application-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}