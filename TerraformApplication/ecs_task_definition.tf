# aws_ecs_task_definition.example:
resource "aws_ecs_task_definition" "churn_definition" {
  container_definitions = jsonencode(
    [
      {
        cpu         = 0
        environment = []
        essential   = true
        image       = format("%s%s", aws_ecr_repository.churn_repo.repository_url, ":latest")
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = "/ecs/churn-application"
            awslogs-region        = "us-east-1"
            awslogs-stream-prefix = "ecs"
          }
        }
        memoryReservation = 128
        mountPoints       = []
        name              = "churn-application-container"
        portMappings = [
          {
            containerPort = 5000
            hostPort      = 5000
            protocol      = "tcp"
          },
        ]
        volumesFrom = []
      },
    ]
  )
  cpu                = "1024"
  execution_role_arn = local.ecs_task_role
  family             = "churn-application"
  memory             = "4096"
  network_mode       = "awsvpc"
  requires_compatibilities = [
    "FARGATE",
  ]
  tags          = local.tags
  task_role_arn = local.ecs_task_role
  depends_on = [
    aws_ecs_cluster.churn_cluster,
  ]
}