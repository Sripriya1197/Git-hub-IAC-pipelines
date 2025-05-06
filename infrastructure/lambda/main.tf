# IAM role for Lambda execution (using terraform-aws-modules/iam/aws module)
module "lambda_role" {
  source = "terraform-aws-modules/iam/aws"

  name = "my-lambda-execution-role"

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
        Version = "2012-10-17"
        Statement = [{
          Action   = ["logs:*", "cloudwatch:*", "xray:*"]
          Effect   = "Allow"
          Resource = "*"
        }]
      })
    }
  ]
}

# Lambda function (using terraform-aws-modules/lambda/aws module with ECR image)
module "lambda_function" {
  source        = "terraform-aws-modules/lambda/aws"
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

# EventBridge rule (using terraform-aws-modules/eventbridge/aws module)
module "eventbridge_rule" {
  source = "terraform-aws-modules/eventbridge/aws"

  name        = "my-event-rule"
  description = "Trigger Lambda function based on events"
  event_pattern = jsonencode({
    "source" = ["aws.events"]
  })
}

# EventBridge target to invoke Lambda (using terraform-aws-modules/eventbridge/aws module)
module "eventbridge_target" {
  source = "terraform-aws-modules/eventbridge/aws"

  rule       = module.eventbridge_rule.name
  target_id  = "LambdaTarget"
  arn        = module.lambda_function.function_arn
  input      = jsonencode({
    "key" = "value"
  })
}

# Lambda permission for EventBridge to invoke the Lambda function (using terraform-aws-modules/lambda/aws module)
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = module.eventbridge_rule.arn
}
