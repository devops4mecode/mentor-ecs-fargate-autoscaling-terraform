resource "aws_ecs_cluster" "dev_to" {
  name = "do4m"
  capacity_providers = [
    "FARGATE"]
  setting {
    name = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "do4m"
    Project = "do4m"
    Billing = "do4m"
  }
}

resource "aws_ecs_task_definition" "dev_to" {
  family = "do4m"
  container_definitions = <<TASK_DEFINITION
  [
  {
    "portMappings": [
      {
        "hostPort": 80,
        "protocol": "tcp",
        "containerPort": 80
      }
    ],
    "cpu": 512,
    "environment": [
      {
        "name": "AUTHOR",
        "value": "Najib Radzuan"
      }
    ],
    "memory": 1024,
    "image": "dockersamples/static-site",
    "essential": true,
    "name": "site",
    "logConfiguration": {
    "logDriver": "awslogs",
    "secretOptions": null,
    "options": {
    "awslogs-group": "${var.aws_cloudwatch_log_group.name}",
    "awslogs-region": "ap-southeast-1",
    "awslogs-stream-prefix": "ecs"
        }
    }
    }
]
TASK_DEFINITION

  network_mode = "awsvpc"
  requires_compatibilities = [
    "FARGATE"]
  memory = "1024"
  cpu = "512"
  execution_role_arn = var.ecs_role.arn
  task_role_arn = var.ecs_role.arn

  tags = {
    Name = "do4m"
    Project = "do4m"
    Billing = "do4m"
  }
}

resource "aws_ecs_service" "dev_to" {
  name = "do4m"
  cluster = aws_ecs_cluster.dev_to.id
  task_definition = aws_ecs_task_definition.dev_to.arn
  desired_count = 1
  launch_type = "FARGATE"
  platform_version = "1.4.0"

  lifecycle {
    ignore_changes = [
      desired_count]
  }

  network_configuration {
    subnets = [
      var.ecs_subnet_a.id,
      var.ecs_subnet_b.id,
      var.ecs_subnet_c.id]
    security_groups = [
      var.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.ecs_target_group.arn
    container_name = "site"
    container_port = 80
  }
}