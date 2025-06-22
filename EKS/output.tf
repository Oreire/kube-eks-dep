output "debug_node_group_scaling" {
  value = {
    min_size         = var.min_size
    desired_capacity = var.desired_capacity
    max_size         = var.max_size
  }
}

