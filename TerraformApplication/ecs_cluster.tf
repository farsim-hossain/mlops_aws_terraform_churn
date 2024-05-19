resource "aws_ecs_cluster" "churn_cluster" {
  capacity_providers = [
    "FARGATE",
    "FARGATE_SPOT",
  ]
  name = "churn-application-cluster"
  tags = local.tags


  setting {
    name  = "containerInsights"
    value = "disabled"
  }
  depends_on = [
    aws_lb_listener.churn_connection,
  ]
}