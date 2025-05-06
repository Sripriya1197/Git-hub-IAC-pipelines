data "aws_ecr_authorization_token" "token" {}

provider "docker" {
  registry_auth {
    address  = "273354669111.dkr.ecr.ap-south-1.amazonaws.com"
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "my-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions   = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]
  }
}

module "docker_image" {
  source = "terraform-aws-modules/lambda/aws//modules/docker-build"
  version = "~> 7.4"

  create_ecr_repo = true
  ecr_repo        = "my-lambda-ecr-repo"

  source_path     = "." 
  image_tag       = "1.0"
  use_image_tag   = true
}

module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"
  version = "~> 7.4"

  function_name  = "my-docker-lambda"
  create_package = false
  package_type   = "Image"
  image_uri      = module.docker_image.image_uri

  role = aws_iam_role.lambda_role.arn  
}
