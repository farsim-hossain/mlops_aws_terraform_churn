locals {
  code_build_service_role = "arn:aws:iam::143176219551:role/service-role/churn-application-role"
  code_commit_repo_name   = "churn-prediction"
  code_commit_location    = "https://git-codecommit.us-east-1.amazonaws.com/v1/repos/churn-prediction"
  code_pipeline_role      = "arn:aws:iam::143176219551:role/service-role/AWSCodePipelineServiceRole-us-east-1-churn_pipeline"
  ecs_service_role        = "arn:aws:iam::143176219551:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
  ecs_task_role           = "arn:aws:iam::143176219551:role/ecsTaskExecutionRole"
  vpc_id                  = "vpc-059d7278"
  tags = {
    application = "churn-prediction"
  }
}