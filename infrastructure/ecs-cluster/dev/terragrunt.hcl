terraform {
  source = "git::https://github.com/Sripriya1197/terraform-module.git//.modules/aws/ecs"
}

inputs = {
  cluster_name              = "dev-Spring-ecs-cluster"
  cloudwatch_log_group_name = "/aws/ecs/sample-app-dev"
  create                    = true

  services = {
    sample-app = {
      cpu    = 256
      memory = 512 
 
      assign_public_ip = true  

      container_definitions = {
        sample-app-container = {
          image     = "696659996381.dkr.ecr.us-east-1.amazonaws.com/dev/sample-spring"
          essential = true
          port_mappings = [
            {
              containerPort = 80
              protocol      = "tcp"
            } 
          ]
          log_configuration = {
            log_driver = "awslogs"
            options = {
              awslogs-group         = "/aws/ecs/my-new-app-dev"
              awslogs-region        = "ap-south-1"
              awslogs-stream-prefix = "ecs"
            }
          }
        }
      }

      subnet_ids = ["subnet-07e2edb18a86869ee"]

      security_group_rules = {
        allow_http = {
          type        = "ingress"
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
        allow_all_egress = {
          type        = "egress"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }

      task_execution_role_arn = "arn:aws:iam::273354669111:role/ecsTaskExecutionRole"
    }
  }
}