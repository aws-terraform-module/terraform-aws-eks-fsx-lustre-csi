# Input Variables - Placeholder file
# AWS Region
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type = string
  default = "us-east-1"  
}

# Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type = string
  default = "dev"
}
# Product Name
variable "product_name" {
  description = "Product Name in the large organization this Infrastructure belongs"
  type = string
  validation {
    condition     = length(var.product_name) > 0
    error_message = "Product name must not be empty."
  }
}

variable "eks_cluster_name" {
  description = <<-EOT
    Name of the EKS cluster.
    When using remote state, set this to: data.terraform_remote_state.eks.outputs.cluster_name
    Example remote state configuration:
    data "terraform_remote_state" "eks" {
      backend = "s3"
      config = {
        bucket = "terraform-state"
        key    = "eks/terraform.tfstate"
        region = "us-east-1"
      }
    }
  EOT
  type = string
  validation {
    condition     = length(var.eks_cluster_name) > 0
    error_message = "EKS cluster name must be provided."
  }
}

variable "aws_iam_openid_connect_provider_arn" {
  description = "The ARN assigned by AWS for this provider/data.terraform_remote_state.eks.outputs.aws_iam_openid_connect_provider_arn"
  type = string
  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:oidc-provider/", var.aws_iam_openid_connect_provider_arn))
    error_message = "The OIDC provider ARN must be valid and start with 'arn:aws:iam::' followed by the account ID and ':oidc-provider/'."
  }
}

variable "eks_cluster_endpoint" {
  description = "The hostname (in form of URI) of Kubernetes master/data.terraform_remote_state.eks.outputs.cluster_endpoint"
  type = string
  validation {
    condition     = can(regex("^https://", var.eks_cluster_endpoint))
    error_message = "The cluster endpoint must be a valid HTTPS URL."
  }
}

variable "eks_cluster_certificate_authority_data" {
  description = "PEM-encoded root certificates bundle for TLS authentication./data.terraform_remote_state.eks.outputs.cluster_certificate_authority_data"
  type = string
  validation {
    condition     = can(base64decode(var.eks_cluster_certificate_authority_data))
    error_message = "The certificate authority data must be base64 encoded."
  }
}