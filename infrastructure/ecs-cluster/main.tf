module "ecs_cluster" {
  source = "terraform-aws-modules/ecs/aws"
  cluster_name = "my-ecs-tf-cluster"
}

module "ecs_service" {
  source          = "terraform-aws-modules/ecs/aws"
  cluster         = module.ecs_cluster.cluster_id
  name            = "my-ecs-sample-service"
  desired_count   = 1
  launch_type     = "FARGATE"
  
  # ECS service task definition
  task_definitions = [
    {
      family = "my-ecs-sample-task"
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
  ]
  
  network_configuration = {
    subnets          = ["subnet-0697385b41cf20408"]
    security_groups  = ["sg-0ef52138839aef07e"]
    assign_public_ip = true
    execution_role_arn = "arn:aws:iam::273354669111:role/ecsTaskExecution"
    task_role_arn      = "arn:aws:iam::273354669111:role/ecsTaskExecution"
  }
}
