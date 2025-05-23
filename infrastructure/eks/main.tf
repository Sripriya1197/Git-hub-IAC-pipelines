module "eks" {  
  source  = "git::https://github.com/Sripriya1197/terraform-module.git//.modules/aws/eks?ref=main"
  cluster_name = "my-eks-tf-cluster"

  cluster_endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true

  subnet_ids               =["subnet-0cc71f61342a9a205", "subnet-0a433e5614138a125"]
  vpc_id                   ="vpc-0a19349c1563bf053"
  control_plane_subnet_ids =["subnet-0cc71f61342a9a205", "subnet-0a433e5614138a125"]

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
