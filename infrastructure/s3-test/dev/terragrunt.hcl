terraform {
  source = "git::https://github.com/Sripriya1197/terraform-module.git//.modules/aws/s3"
}

inputs = {
  bucket = "my-dev-bucket-2105-tf"
  acl         = "private"
  tags = {
    Environment = "dev"
    Owner       = "dev-team"
  }  
}    