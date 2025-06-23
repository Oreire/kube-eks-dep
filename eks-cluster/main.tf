provider "aws" {
  region = var.region
}

# Remote state to pull public subnets and VPC ID
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "my-eksproject-store"
    key    = "env/vpc/terraform.tfstate"
    region = var.region
  }
}

# IAM role for the EKS control plane
resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "eks.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# EKS Cluster
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = [
      data.terraform_remote_state.vpc.outputs.public_subnet_1,
      data.terraform_remote_state.vpc.outputs.public_subnet_2
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
}

# IAM role for worker nodes
resource "aws_iam_role" "eks_node" {
  name = "eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_node_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ])
  policy_arn = each.key
  role       = aws_iam_role.eks_node.name
}

# 1️⃣ Attach this to the IAM role's inline or managed permissions
# resource "aws_iam_role_policy" "eks_actions" {
#   role = aws_iam_role.github_oidc_role.name
#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [{
#       Effect   = "Allow",
#       Action   = [
#         "eks:UpdateClusterConfig",
#         "eks:DeleteCluster",
#         "eks:DescribeCluster",
#         "eks:DescribeNodegroup",
#         "eks:DeleteNodegroup",
#         "eks:ListNodegroups"
#       ],
#       Resource = "*"
#     }]
#   })
# }

# 2️⃣ Attach this as the trust policy
resource "aws_iam_role" "github_oidc_role" {
  name = "eks-teardown-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = "arn:aws:iam::<account-id>:oidc-provider/token.actions.githubusercontent.com"
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com",
          "token.actions.githubusercontent.com:sub" = "repo:Oreire/kube-eks-dep:*"
        }
      }
    }]
  })
}

# EKS Managed Node Group
resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "laredo-nodes"
  node_role_arn   = aws_iam_role.eks_node.arn

  subnet_ids = [
    data.terraform_remote_state.vpc.outputs.public_subnet_1,
    data.terraform_remote_state.vpc.outputs.public_subnet_2
  ]

  scaling_config {
    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size
  }

  instance_types = ["t3.small"]
  ami_type       = "AL2_x86_64"
  disk_size      = 20

  labels = {
    role       = "web-node"
    environment = "dev"
    zone-aware = "true"
  }

  depends_on = [aws_iam_role_policy_attachment.eks_node_policies]
}

