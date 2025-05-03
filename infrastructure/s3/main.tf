provider "aws" {
  region = "ap-south-1"
}
module "s3_bucket" {
  source = "../../.modules/aws/s3"

  bucket = "my-s3-bucket"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
}
