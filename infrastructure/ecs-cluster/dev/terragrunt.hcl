terraform {
  source = "tfr:///terraform-aws-modules/ecs/aws?version=5.12.1"
}

inputs = {
  cluster_name              = "dev-ecs-cluster"
  cloudwatch_log_group_name = "/aws/ecs/sample-app-dev"
  region                    = "ap-south-1"
}