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
            "xray:*",
            "apigateway:*" # Add API Gateway permissions
          ]
          Effect   = "Allow"
          Resource = "*"
        }]
      })
    }
  ]
}

# Lambda Function Module (using Docker image from ECR)
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

# API Gateway for triggering Lambda
resource "aws_api_gateway_rest_api" "lambda_api" {
  name        = "lambda-api"
  description = "API for Lambda function"
}

resource "aws_api_gateway_resource" "lambda_resource" {
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  parent_id   = aws_api_gateway_rest_api.lambda_api.root_resource_id
  path_part   = "trigger"
}

resource "aws_api_gateway_method" "lambda_method" {
  rest_api_id   = aws_api_gateway_rest_api.lambda_api.id
  resource_id   = aws_api_gateway_resource.lambda_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  resource_id = aws_api_gateway_resource.lambda_resource.id
  http_method = aws_api_gateway_method.lambda_method.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri  = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${module.lambda_function.lambda_function_arn}/invocations"
}

resource "aws_lambda_permission" "allow_api_gateway" {
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_function.lambda_function_name
  principal     = "apigateway.amazonaws.com"
}
