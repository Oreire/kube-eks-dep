# variables declaration for EKS Cluster
variable "min_size" {
  description = "Minimum number of nodes"
  type        = number
  default     = 2
}

variable "desired_size" {
  description = "Desired number of nodes"
  type        = number
  default     = 3

  validation {
    condition     = var.desired_size >= var.min_size
    error_message = "desired_size must be greater than or equal to min_size."
  }
}

variable "max_size" {
  description = "Maximum number of nodes"
  type        = number
  default     = 5

  validation {
    condition     = var.max_size >= var.desired_size
    error_message = "max_size must be greater than or equal to desired_size."
  }
}



variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "laredo-cluster"
}

