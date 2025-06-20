# S3 Backend to store state file for VPC and associated infastructure

terraform {
  backend "s3" {
    bucket = "my-eksproject-store"
    key    = "env/vpc/terraform.tfstate"
    region = "eu-west-2"
  }
}