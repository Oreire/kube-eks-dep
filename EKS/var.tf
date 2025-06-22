# variables.tf

variable "min_size" {
  description = "Minimum number of nodes in the node group"
  type        = number
}

variable "desired_capacity" {
  description = "Desired number of nodes in the node group"
  type        = number

  validation {
    condition     = var.desired_capacity >= var.min_size
    error_message = "desired_capacity must be greater than or equal to min_size."
  }
}

variable "max_size" {
  description = "Maximum number of nodes in the node group"
  type        = number

  validation {
    condition     = var.max_size >= var.desired_capacity
    error_message = "max_size must be greater than or equal to desired_capacity."
  }
}

