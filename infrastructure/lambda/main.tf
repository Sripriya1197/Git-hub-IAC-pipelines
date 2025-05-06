module "docker_image" {
  source = "terraform-aws-modules/lambda/aws//modules/docker-build"
  version = "~> 7.4"

  create_ecr_repo = true
  ecr_repo        = "my-lambda-ecr-repo"

  source_path     = "."       
  image_tag       = "1.0"
  use_image_tag   = true
}

module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"
  version = "~> 7.4"

  function_name  = "my-docker-lambda"
  create_package = false

  package_type = "Image"
  image_uri    = module.docker_image.image_uri
}
