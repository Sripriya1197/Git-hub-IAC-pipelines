module "lambda_role" {
  source = "terraform-aws-modules/iam/aws"

  role_name = "my-lambda-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })

  policies = [
    {
      name   = "lambda-basic-execution-policy"
      policy = jsonencode({
        Version   = "2012-10-17"
        Statement = [{
          Action   = [
            "logs:*",
            "cloudwatch:*",
            "xray:*"
          ]
          Effect   = "Allow"
          Resource = "*"
        }]
      })
    }
  ]
}
module "lambda_function" {
  source        = "git::https://github.com/Sripriya1197/terraform-module.git//.modules/aws/lambda?ref=main"
  function_name = "my-lambda-function"
  role          = module.lambda_role.role_arn
  package_type  = "Image"
  image_uri     = "273354669111.dkr.ecr.ap-south-1.amazonaws.com/lambda:1.0.0"
  timeout       = 10
  memory_size   = 128

  environment_variables = {
    ENV = "dev"
  }
}
