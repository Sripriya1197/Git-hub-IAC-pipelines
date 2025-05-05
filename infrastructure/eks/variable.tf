module "eks" {  
  source  = "git::https://github.com/Sripriya1197/terraform-module.git//.modules/aws/eks?ref=main"
  cluster_name = var.cluster_name

  cluster_endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true

  subnet_ids               = var.subnet_ids
   vpc_id                   = var.vpc_id

  eks_managed_node_group_defaults = {
    instance_types = ["t3.medium"]   
  }

  eks_managed_node_groups = {  
    eks-node = {
      ami_type       = "AL2023_x86_64_STANDARD" 
      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 1
      desired_size = 1
    }
  }

  tags = {
    Environment = "prod"
    Terraform   = "true"
  }
}
