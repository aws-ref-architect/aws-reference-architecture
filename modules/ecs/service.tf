resource "aws_ecs_service" "service" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = 3
  iam_role        = aws_iam_role.service.arn
  depends_on      = [aws_iam_role_policy.ecs_services]
  launch_type = "EC2"

  ordered_placement_strategy {
    type  = "spread"
    field = "host"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.service.arn
    container_name   = var.service_name
    container_port   = 8080
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in ${var.availability_zones}"
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
}

resource "aws_ecs_task_definition" "service" {
  family = "service"
  network_mode             = "awsvpc"
  cpu       = 1024
  memory    = 512
  container_definitions = jsonencode([
    {
      name      = "service"
      image     = "service:1.0.0"
      cpu       = 1024
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])

  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "host"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in ${var.availability_zones}"
  }
}