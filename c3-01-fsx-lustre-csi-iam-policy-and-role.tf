resource "aws_iam_role" "fsx_csi_driver_role" {
  name = "${local.name}-fsx-lustre-csi-iam-role"

  # Terraform's "jsonencode" function converts a Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Federated = "${var.aws_iam_openid_connect_provider_arn}"
        }
        Condition = {
          StringEquals = {            
            "${local.aws_iam_openid_connect_provider_extract_from_arn}:sub": "system:serviceaccount:kube-system:fsx-csi-controller-sa"
          }
        }        

      },
    ]
  })
}

resource "aws_iam_policy_attachment" "fsx_full_access" {
  name       = "fsx-full-access"
  policy_arn = "arn:aws:iam::aws:policy/AmazonFSxFullAccess"
  roles      = [aws_iam_role.fsx_csi_driver_role.name]
}

output "fsx_lustre_csi_iam_role_arn" {
  description = "EBS CSI IAM Role ARN"
  value = aws_iam_role.fsx_csi_driver_role.arn
}