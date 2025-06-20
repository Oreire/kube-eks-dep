resource "aws_cloudwatch_log_group" "eks_cluster" {
  name              = "/aws/eks/laredo-cluster/cluster"
  retention_in_days = 7

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
    ignore_changes        = [tags]
  }

  tags = {
    Name        = "eks-cluster-logs"
    Environment = "dev"
  }
}

