provider "aws" {
  region = "ap-south-1" 
}
module "ec2_instance" {
   source = "git::https://github.com/Sripriya1197/terraform-module.git//.modules/aws/ec2?ref=main"

  //   count              =   var.count    
     region             =   var.region
     ami                =   var.region
     key_name           =   var.key_name
     instance_type      =   var.instance_type
     subnet_id          =   var.subnet_id
     vpc_security_group_ids = var.vpc_security_group_ids

   tags ={
     Name = var.instance_name
   }

}




