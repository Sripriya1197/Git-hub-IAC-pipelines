include {
  path = find_in_parent_folders()
}
terraform {
  source = "git::https://github.com/Sripriya1197/terraform-module.git//.modules/aws/s3"
}

inputs = {
  bucket = "my-dev-bucket-20052025"
  acl         = "private"
  tags = {
    Environment = "dev"
    Owner       = "dev-team"
  }
}