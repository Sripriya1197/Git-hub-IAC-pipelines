module "ecs" {  
  source = "git::https://github.com/Sripriya1197/terraform-module.git//.modules/aws/ecs?ref=main"
 

  cluster_name = "my-ecs-tf-cluster"  
  
  services = {
    sample-app = {
      cpu    = 256
      memory = 512   

      assign_public_ip = true   

      container_definitions = {
        sample-app-container = {
          image     = "273354669111.dkr.ecr.ap-south-1.amazonaws.com/sample_app:1.0.0"
          essential = true
          port_mappings = [
            {
              containerPort = 80
              protocol      = "tcp"
            }
          ]
        
         }
      }

      subnet_ids = [
        "subnet-0697385b41cf20408"
      ]

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
