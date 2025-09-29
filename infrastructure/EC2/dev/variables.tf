variable "name" {
  description = "Name to be used on EC2 instance created"
  type        = string
  default     = ""
}
variable "ami" {
  description = "ID of AMI to use for the instance"
  type        = string
  default     = null
}
variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t3.micro"
}
variable "key_name" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
  type        = string
  default     = null
}
variable "subnet_id" {
  description = "The VPC Subnet ID to launch in"
  type        = string
  default     = null
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
  default     = []
}
variable "tags" {
  type    = map(string)
  default = {}
}
