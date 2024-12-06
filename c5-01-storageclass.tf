resource "kubernetes_storage_class" "fsx_lustre" {
  count = var.create_fsx_storage_class ? 1 : 0  # Conditionally create the resource

  metadata {
    name = "fsx-sc"
  }

  storage_provisioner = "fsx.csi.aws.com"  # Correct attribute for provisioner

  parameters = {
    subnetId                       = var.fsx_subnet_id
    securityGroupIds               = local.final_security_group_ids
    deploymentType                 = var.fsx_deployment_type
    automaticBackupRetentionDays   = tostring(var.fsx_backup_retention_days)
    dailyAutomaticBackupStartTime  = var.fsx_backup_start_time
    copyTagsToBackups             = var.fsx_copy_tags_to_backups
    perUnitStorageThroughput      = tostring(var.fsx_storage_throughput)
    dataCompressionType           = var.fsx_data_compression
    weeklyMaintenanceStartTime    = var.fsx_maintenance_window
    fileSystemTypeVersion         = var.fsx_version
    extraTags                     = var.fsx_extra_tags
  }

  mount_options = var.fsx_mount_options

  reclaim_policy = var.fsx_reclaim_policy  # Reclaim policy (Delete or Retain)
}