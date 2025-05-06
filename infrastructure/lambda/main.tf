# IAM role for Lambda execution (using terraform-aws-modules/iam/aws module)
module "lambda_role" {
  source = "terraform-aws-modules/iam/aws"

  role_name = "my-lambda-execution-role"  # Use 'role_name' instead of 'name'

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

  # Define policy directly as a single object
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
resource "aws_lambda_function" "lambda_function" {
  function_name = "my-lambda-function"
  role          = module.lambda_role.role_arn
  package_type  = "Image"
  image_uri     = "273354669111.dkr.ecr.ap-south-1.amazonaws.com/lambda:1.0.0"
  timeout       = 10
  memory_size   = 128

  environment {
    variables = {
      ENV = "dev"
    }
  }
}

# EventBridge rule (using aws_cloudwatch_event_rule resource)
resource "aws_cloudwatch_event_rule" "event_rule" {
  name        = "my-event-rule"
  description = "Trigger Lambda function based on events"
  event_pattern = jsonencode({
    "source" = ["aws.events"]
  })
}

# EventBridge target to invoke Lambda (using aws_cloudwatch_event_target resource)
resource "aws_cloudwatch_event_target" "event_target" {
  rule       = aws_cloudwatch_event_rule.event_rule.name
  target_id  = "LambdaTarget"
  arn        = aws_lambda_function.lambda_function.arn
  input      = jsonencode({
    "key" = "value"
  })
}

# Lambda permission for EventBridge to invoke the Lambda function
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.event_rule.arn
}
