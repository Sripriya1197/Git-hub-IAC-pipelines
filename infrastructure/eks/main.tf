module "eks" {  
  source  = "git::https://github.com/Sripriya1197/terraform-module.git//.modules/aws/eks?ref=main"
  cluster_name = "my-eks-tf-cluster"
  vpc_id       = "vpc-05601e20ad2591eb0"
  subnet_ids = ["subnet-0422988b659d1f0a1","subnet-0b09b067c081e2a26"]
  control_plane_subnet_ids = ["subnet-0422988b659d1f0a1","subnet-0b09b067c081e2a26"]
  eks_managed_node_groups = {
    sample-app-tf = {
      instance_types = ["t3.medium"] 
      min_size       = 1  
      max_size       = 1    
      desired_size   = 1
    }
  }

  tags = {
    Environment = "prod"
    Terraform   = "true"
  }
}
