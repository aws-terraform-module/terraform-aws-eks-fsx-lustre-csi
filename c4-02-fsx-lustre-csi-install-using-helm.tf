# Install EBS CSI Driver using HELM
# Resource: Helm Release 
resource "helm_release" "fsx_lustre_csi_driver" {
  depends_on = [aws_iam_role.fsx_csi_driver_role]
  name       = "fsx-csi-driver-role"
  repository = "https://kubernetes-sigs.github.io/aws-fsx-csi-driver"
  chart      = "aws-fsx-csi-driver"
  namespace = "kube-system"     
      
  set {
    name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "${aws_iam_role.fsx_csi_driver_role.arn}"
  }
}