provider "aws" {
  region = "eu-west-2"
}

# Backend configuration for storing the Terraform state file in S3

# It retrieves the VPC and subnet information from a remote state file stored in S3.
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "my-eksproject-store"
    key    = "env/vpc/terraform.tfstate"
    region = "eu-west-2"
  }
}
# This module creates an EKS cluster using the Terraform AWS EKS module.
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 20.0" # Use the latest major version
  cluster_name    = var.cluster_name
  cluster_version = "1.29"
  create_cloudwatch_log_group = false
  vpc_id          = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids = concat(
  [data.terraform_remote_state.vpc.outputs.public_subnet_1],
  [data.terraform_remote_state.vpc.outputs.public_subnet_2],
  [data.terraform_remote_state.vpc.outputs.private_subnet_1],
  [data.terraform_remote_state.vpc.outputs.private_subnet_2]
)


  eks_managed_node_groups = {
    laredo-nodes = {
      instance_types   = ["t2.micro"]
      desired_capacity = 4
      min_size         = 3
      max_size         = 6
      
      # Required tags for autoscaler
      tags = {
        "k8s.io/cluster-autoscaler/enabled"             = "true"
        "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
      }
    }
  }

}

