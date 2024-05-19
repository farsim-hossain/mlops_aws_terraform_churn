resource "aws_codebuild_project" "churn_build" {
  badge_enabled          = false
  build_timeout          = 60
  description   = "churn-application_codebuild_project"
  concurrent_build_limit = 1
  name                   = "churn-application-build-project"
  source_version         = "refs/heads/master"
  queued_timeout         = 480
  service_role           = local.code_build_service_role
  tags                   = local.tags

  artifacts {
    encryption_disabled    = false
    location               = "codepipeline-us-east-1-112741295250"
    name                   = "churn-application"
    namespace_type         = "NONE"
    override_artifact_name = false
    packaging              = "ZIP"
    type                   = "S3"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
    type                        = "LINUX_CONTAINER"

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      type  = "PLAINTEXT"
      value = "us-east-1"
    }
    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      type  = "PLAINTEXT"
      value = "143176219551"
    }
    environment_variable {
      name  = "IMAGE_REPO_NAME"
      type  = "PLAINTEXT"
      value = "churn-application-repo"
    }
    environment_variable {
      name  = "IMAGE_TAG"
      type  = "PLAINTEXT"
      value = "latest"
    }
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }

    s3_logs {
      encryption_disabled = false
      status              = "DISABLED"
    }
  }

  source {
    git_clone_depth     = 1
    insecure_ssl        = false
    location            = local.code_commit_location
    report_build_status = false
    type                = "CODECOMMIT"

    git_submodules_config {
      fetch_submodules = false
    }
  }
  depends_on = [
    aws_ecr_repository.churn_repo,
  ]
}
