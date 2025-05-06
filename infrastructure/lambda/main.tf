module "lambda_function" {
  source ="terraform-aws-modules/lambda/aws"
  version = "~> 7.4"
 
  function_name  = var.function_name
  create_package = false
  package_type   = "Image"
  image_uri      = var.image_uri
}   
