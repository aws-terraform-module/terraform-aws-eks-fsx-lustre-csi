# Terraform Settings Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
     }
    helm = {
      source = "hashicorp/helm"
      #version = "2.4.1"
      version = "~> 2.4"
    }
    http = {
      source = "hashicorp/http"
      #version = "2.1.0"
      version = "~> 3.0"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
#   # Adding Backend as S3 for Remote State Storage
#   backend "s3" {
#      bucket = "private-windows-nim-eks-tf-lock"
#      key    = "fsx-lustre.tfstate"
#      region = "us-east-1" 

#      # For State Locking
#      dynamodb_table = "private-windows-nim-eks-tf-lock"    
#   }     
}

#Terraform AWS Provider Block
provider "aws" {
  region = var.aws_region
}