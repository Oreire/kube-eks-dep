resource "aws_cloudwatch_log_group" "eks_cluster" {
  name              = "/aws/eks/laredo-cluster/cluster"
  retention_in_days = 7

  lifecycle {
    prevent_destroy       = false
    create_before_destroy = true
    ignore_changes        = [tags]
  }

  tags = {
    Name        = "eks-cluster-logs"
    Environment = "dev"
  }
}

# resource "aws_cloudwatch_log_group" "eks_node_group" {
#   name              = "/aws/eks/laredo-cluster/nodegroup"
#   retention_in_days = 7

#   lifecycle {
#     prevent_destroy       = false
#     create_before_destroy = true
#     ignore_changes        = [tags]
#   }

#   tags = {
#     Name        = "eks-nodegroup-logs"
#     Environment = "dev"
#   }
# }