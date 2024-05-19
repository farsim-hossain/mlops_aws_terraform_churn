resource "aws_codepipeline" "churn_pipeline" {
  name     = "churn_pipeline"
  role_arn = local.code_pipeline_role
  tags     = local.tags

  artifact_store {
    location = "codepipeline-us-east-1-112741295250"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      category = "Source"
      configuration = {
        "BranchName"           = "master"
        "OutputArtifactFormat" = "CODE_ZIP"
        "PollForSourceChanges" = "false"
        "RepositoryName"       = local.code_commit_repo_name
      }
      input_artifacts = []
      name            = "Source"
      namespace       = "SourceVariables"
      output_artifacts = [
        "SourceArtifact",
      ]
      owner     = "AWS"
      provider  = "CodeCommit"
      region    = "us-east-1"
      run_order = 1
      version   = "1"
    }
  }
  stage {
    name = "Build"

    action {
      category = "Build"
      configuration = {
        "ProjectName" = aws_codebuild_project.churn_build.name
      }
      input_artifacts = [
        "SourceArtifact",
      ]
      name      = "Build"
      namespace = "BuildVariables"
      output_artifacts = [
        "BuildArtifact",
      ]
      owner     = "AWS"
      provider  = "CodeBuild"
      region    = "us-east-1"
      run_order = 1
      version   = "1"
    }
  }
  stage {
    name = "Deploy"

    action {
      category = "Deploy"
      configuration = {
        "ClusterName" = aws_ecs_cluster.churn_cluster.name
        "ServiceName" = aws_ecs_service.churn_service.name
      }
      input_artifacts = [
        "BuildArtifact",
      ]
      name             = "Deploy"
      namespace        = "DeployVariables"
      output_artifacts = []
      owner            = "AWS"
      provider         = "ECS"
      region           = "us-east-1"
      run_order        = 1
      version          = "1"
    }
  }
  depends_on = [
    aws_ecs_service.churn_service,
  ]
}