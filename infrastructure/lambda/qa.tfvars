
variable "function_name" {
  description = "A unique name for your Lambda Function"
  type        = string
  default     = "my-f2c-qa-lambda"
}

variable "image_uri" {
  description = "The ECR image URI containing the function's deployment package."
  type        = string
  default     = "273354669111.dkr.ecr.ap-south-1.amazonaws.com/lambda:1.0.0"
}
