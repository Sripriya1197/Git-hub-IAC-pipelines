variable "cluster_name" {
  description = "Name of the cluster (up to 255 letters, numbers, hyphens, and underscores)"
  type        = string
  default     = "my-ecs-dev-cluster"
}
variable "environment" {
  type        = string
  description = "Environment name like dev, stage, prod"
  default     = "dev"
}


