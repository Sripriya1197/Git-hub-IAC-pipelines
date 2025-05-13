terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-s3.git//?ref=v5.9.1"
}

inputs = {
     bucket =my-tf-s3-dev-2025
     acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
}