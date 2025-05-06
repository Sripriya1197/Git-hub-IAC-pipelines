# IAM role for Lambda execution (using terraform-aws-modules/iam/aws module)
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

# Lambda function (using aws_lambda_function resource with ECR image)
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

  event_bus_name = "default"  # Default event bus, can be customized
  event_pattern  = jsonencode({
    "source" = ["aws.events"]
  })

  # We removed the unsupported arguments (name, description)
}

# EventBridge target to invoke Lambda (using terraform-aws-modules/eventbridge/aws module)
module "eventbridge_target" {
  source = "terraform-aws-modules/eventbridge/aws"

  rule_arn  = module.eventbridge_rule.arn  # Corrected 'rule' to 'rule_arn'
  targets = [
    {
      arn = module.lambda_function.lambda_arn
      id  = "LambdaTarget"  # Corrected 'target_id' to 'id'
      input = jsonencode({
        "key" = "value"
      })
    }
  ]
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
