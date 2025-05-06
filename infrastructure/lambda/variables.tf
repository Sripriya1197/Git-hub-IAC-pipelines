variable "function_name" {
  description = "A unique name for your Lambda Function"
  type        = string
  default     = ""
}
variable "image_uri" {
  description = "The ECR image URI containing the function's deployment package."
  type        = string
  default     = null
}
