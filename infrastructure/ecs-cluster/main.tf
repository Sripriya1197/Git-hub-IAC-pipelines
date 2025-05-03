module "ecs_cluster" {
  source             = "git::https://github.com/Sripriya1197/terraform-module.git//.modules/aws/ecs?ref=main"
  version            = "~> 4.0"
  name               = "my-ecs-cluster"
  capacity_providers = ["FARGATE"]
  create_cluster     = true
}

module "ecs_task_definition" {
  source = "terraform-aws-modules/ecs/aws//modules/task-definition"
  family = "myapp-task"
  container_definitions = jsonencode([{
    name  = "my-container"
    image = "273354669111.dkr.ecr.ap-south-1.amazonaws.com/github-action:1.1.1"
    portMappings = [{
      containerPort = 80
      protocol      = "tcp"
    }]
  }])
  cpu                      = 256
  memory                   = 512
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
}

module "ecs_service" {
  source          = "terraform-aws-modules/ecs/aws//modules/service"
  name            = "myapp-service"
  cluster         = module.ecs_cluster.cluster_id
  task_definition = module.ecs_task_definition.task_definition_arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration = {
    subnets          = ["subnet-0697385b41cf20408"]
    security_groups  = ["sg-0ef52138839aef07e"]
    assign_public_ip = true
  }
}
