terraform {
  source = "git::https://github.com/Sripriya1197/terraform-module.git//.modules/aws/s3"
}

inputs = {
  bucket = "my-qa-bucket-2105-tf"
  acl         = "private"
  tags = {
    Environment = "qa"
    Owner       = "qa-team"
  }  
}    