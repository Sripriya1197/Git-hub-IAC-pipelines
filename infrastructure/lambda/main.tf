# Lambda role module (using terraform-aws-modules/iam/aws module)
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

# Lambda function (using terraform-aws-modules/lambda/aws module)
module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

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

# EventBridge Rule (using terraform-aws-modules/eventbridge/aws module)
module "eventbridge_rule" {
  source = "terraform-aws-modules/eventbridge/aws"

  rule_name = "my-event-rule"
  event_pattern = jsonencode({
    "source" = ["aws.events"]
  })

  # event_bus_name is not needed, removing it
}

# EventBridge target to invoke Lambda (using terraform-aws-modules/eventbridge/aws module)
module "eventbridge_target" {
  source = "terraform-aws-modules/eventbridge/aws"

  rule_name  = module.eventbridge_rule.rule_name  # Corrected to rule_name instead of rule_arn
  target_id  = "LambdaTarget"
  arn        = module.lambda_function.lambda_arn
  input      = jsonencode({
    "key" = "value"
  })
}

# Lambda permission for EventBridge to invoke the Lambda function (using terraform-aws-modules/lambda/aws module)
module "lambda_permission" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = module.lambda_function.function_name
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  principal     = "events.amazonaws.com"
  source_arn    = module.eventbridge_rule.arn
}
