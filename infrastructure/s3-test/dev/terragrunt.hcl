terraform {
  source = "git::https://github.com/Sripriya1197/terraform-module/tree/main/.modules/aws/s3?ref=main"
}

inputs = {
  bucket_name = "my-dev-bucket-20052025"
  acl         = "private"
  tags = {
    Environment = "dev"
    Owner       = "dev-team"
  }
}