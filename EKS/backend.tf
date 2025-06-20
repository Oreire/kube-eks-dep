
# S3 Backend to store state file for Frontend Nodes

terraform {
  backend "s3" {
    bucket = "my-eksproject-store"
    key    = "env/eks/terraform.tfstate"
    region = "eu-west-2"
  }
}