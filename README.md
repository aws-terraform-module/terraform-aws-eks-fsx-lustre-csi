### EKS FSX Lustre Terraform module:

We simplify the setup of the FSx Lustre Controller on your EKS cluster, enabling you to provision PVC and PV for Deployments and Pods easily.

### 1) Get VPC and Subnet via Data Source.

To set the FSx Lustre Controller on your EKS cluster, you need to provide something:  
EKS cluster information and VPC and Subnet IDs can be obtained using Terraform data sources.  
Please follow the guidelines below.

```plaintext
data "aws_eks_cluster" "eks" {
  name = var.cluster_id
}

data "aws_vpc" "selected" {
  tags = {
    Name = "vpc_name" # Replace with your VPC's tag name
  }
}

data "aws_subnets" "private_networks" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  filter {
    name   = "tag:Name"
    values = ["staging-nim-engine-private-us-west-2a"]
  }
}

module "eks-fsx-lustre-csi" {
  source  = "aws-terraform-module/eks-fsx-lustre-csi/aws"
  version = "0.0.1"
  aws_region = var.aws_region
  environment = var.environment
  vpc_id = data.aws_vpc.selected.id
  fsx_subnet_id = data.aws_subnets.private_networks.ids[0]
  product_name  = var.product_name
  eks_cluster_certificate_authority_data = data.aws_eks_cluster.eks.certificate_authority[0].data
  eks_cluster_endpoint = data.aws_eks_cluster.eks.endpoint
  eks_cluster_name  = var.cluster_id
  aws_iam_openid_connect_provider_arn = "arn:aws:iam::${element(split(":", "${data.aws_eks_cluster.eks.arn}"), 4)}:oidc-provider/${element(split("//", "${data.aws_eks_cluster.eks.identity[0].oidc[0].issuer}"), 1)}"
}
```