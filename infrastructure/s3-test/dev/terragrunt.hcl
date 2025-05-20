terraform {
  source = "git::https://github.com/Sripriya1197/terraform-module/tree/main/.modules/aws/s3"
}

inputs = {
  bucket_name = "my-dev-bucket-1234"
  acl         = "private"
  tags = {
    Environment = "dev"
    Owner       = "dev-team"
  }
}