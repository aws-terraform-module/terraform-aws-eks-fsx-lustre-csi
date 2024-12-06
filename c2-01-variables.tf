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

# AWS-specific parameters for FSx Lustre
variable "fsx_subnet_id" {
  description = "The ID of the subnet where the FSx Lustre file system will be deployed. exp: `subnet-0eabfaa81fb22bcaf`"
  type        = string
}

variable "fsx_security_group_ids" {
  description = "Comma-separated list of security group IDs to associate with the FSx Lustre file system. Leave empty to create a new security group."
  type        = string
  default     = ""  # Empty by default, meaning Terraform will create a new security group
}

# FSx configuration for backup and maintenance
variable "fsx_backup_retention_days" {
  description = "(Optional) The number of days to retain automatic backups. Setting this to 0 disables automatic backups. You can retain automatic backups for a maximum of 90 days. only valid for PERSISTENT_1 and PERSISTENT_2 deployment_type."
  type        = number
  default     = 0  # Default is 1 day of backup retention
  validation {
    condition     = var.fsx_backup_retention_days >= 0 && var.fsx_backup_retention_days <= 90
    error_message = "Backup retention days must be between 0 and 90."
  }
}

variable "fsx_backup_start_time" {
  description = "(Optional) A recurring daily time, in the format HH:MM. HH is the zero-padded hour of the day (0-23), and MM is the zero-padded minute of the hour. For example, 05:00 specifies 5 AM daily. only valid for `PERSISTENT_1` and `PERSISTENT_2` deployment_type. Requires automatic_backup_retention_days to be set."
  type        = string
  default     = "00:00"  # Midnight UTC
}

variable "fsx_copy_tags_to_backups" {
  description = "(Optional) A boolean flag indicating whether tags for the file system should be copied to backups. Applicable for `PERSISTENT_1` and `PERSISTENT_2` deployment_type. The default value is false."
  type        = bool
  default     = false
}

# FSx performance settings
variable "fsx_storage_throughput" {
  description = "Throughput (in MB/s) per unit of storage for the FSx Lustre file system."
  type        = number
  default     = 200  # Example throughput
}

variable "fsx_data_compression" {
  description = "Compression method for FSx Lustre file system data (NONE or LZ4)."
  type        = string
  default     = "NONE"
}

# FSx maintenance settings
variable "fsx_maintenance_window" {
  description = "Weekly maintenance window start time for FSx Lustre (UTC)."
  type        = string
  default     = "7:09:00"  # Example maintenance time in UTC
}

# FSx file system version and deployment type
variable "fsx_version" {
  description = "(Optional) Sets the Lustre version for the file system that you're creating. Valid values are 2.10 for `SCRATCH_1`, `SCRATCH_2` and `PERSISTENT_1` deployment types. Valid values for 2.12 include all deployment types."
  type        = string
  default     = "2.12"
}

variable "fsx_deployment_type" {
  description = "Deployment type for FSx Lustre (PERSISTENT_2, PERSISTENT_1 or SCRATCH_1)."
  type        = string
  default     = "PERSISTENT_2"  # PERSISTENT_1 for long-term storage, SCRATCH_1 for temporary use
}

# Tags for FSx Lustre file system
variable "fsx_extra_tags" {
  description = "Extra tags for the FSx Lustre file system in the format 'Key=Value'. Multiple tags can be separated by commas."
  type        = string
  default     = ""
}

# Mount options for Kubernetes
variable "fsx_mount_options" {
  description = "List of mount options for the FSx Lustre file system in Kubernetes."
  type        = list(string)
  default     = ["flock"]  # Default mount option for file locking
}

# Flag to control whether the StorageClass should be created
variable "create_fsx_storage_class" {
  description = "Flag to control if the FSx Lustre StorageClass should be created."
  type        = bool
  default     = true
}

# Reclaim policy for the storage class (Retain or Delete)
variable "fsx_reclaim_policy" {
  description = "Reclaim policy for the StorageClass (Retain or Delete)."
  type        = string
  default     = "Delete"  # Can be set to "Retain" or "Delete"
}

# Variable to define the security group name if creating it
variable "vpc_id" {
  description = "provide vpc_id to create security group"
  type        = string
  default     = ""
}



