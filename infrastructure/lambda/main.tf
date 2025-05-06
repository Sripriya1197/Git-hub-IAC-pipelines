module "lambda_function" {
  source ="terraform-aws-modules/lambda/aws"
  version = "~> 7.4"
 
  function_name  = "my-f2c-lambda"
  create_package = false
  package_type   = "Image"
  image_uri      = "273354669111.dkr.ecr.ap-south-1.amazonaws.com/lambda:1.0.0"
}
