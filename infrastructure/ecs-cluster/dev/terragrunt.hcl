terraform {
  source = "git::https://github.com/Sripriya1197/terraform-module.git//.modules/aws/ecs?ref=main"
}

inputs = {
  cluster_name              = "dev-ecs-cluster"
  cloudwatch_log_group_name = "/aws/ecs/sample-app-dev"
  region                    = "ap-south-1"
}