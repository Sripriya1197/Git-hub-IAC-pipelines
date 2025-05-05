module "eks" {  
  source  = "git::https://github.com/Sripriya1197/terraform-module.git//.modules/aws/eks?ref=main"
  cluster_name = "my-eks-tf-cluster"  

  cluster_endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = "vpc-0a19349c1563bf053"
  subnet_ids               = ["subnet-01abbb296e6c29197", "subnet-0d97e9a39a2d34f30"]
  #control_plane_subnet_ids = ["", ""]  

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
