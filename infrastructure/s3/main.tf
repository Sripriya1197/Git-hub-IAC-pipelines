provider "aws" {
  region = "ap-south-1" 
}
module "s3_bucket" {
   source = "git::https://github.com/Sripriya1197/terraform-module.git//.modules/aws/s3?ref=main"

  bucket = var.bucket
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
}
