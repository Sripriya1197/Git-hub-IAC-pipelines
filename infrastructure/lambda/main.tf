terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  registry_auth {
    address  = "273354669111.dkr.ecr.ap-south-1.amazonaws.com"
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}

data "aws_ecr_authorization_token" "token" {}

module "docker_image" {
  source = "terraform-aws-modules/lambda/aws//modules/docker-build"
  
  create_ecr_repo = true
  ecr_repo        = "my-lambda-ecr-repo"  

  source_path     = "."  # Assuming Dockerfile is in the same directory as main.tf
  image_tag       = "1.0"
  use_image_tag   = true
}

module "lambda_function" {
  source = "git::https://github.com/Sripriya1197/terraform-module.git//.modules/aws/lambda?ref=main"

  function_name  = "my-docker-lambda"
  create_package = false

  package_type = "Image"
  image_uri    = module.docker_image.image_uri
}
