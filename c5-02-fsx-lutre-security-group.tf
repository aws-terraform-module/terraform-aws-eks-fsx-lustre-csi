data "aws_vpc" "example" {
  id = var.vpc_id  # replace with your VPC ID
}

resource "aws_security_group" "fsx_sg" {
  count = var.fsx_security_group_ids == "" ? 1 : 0

  name        = "${local.name}fsx-lustre-sg"
  description = "Security group for FSx Lustre file system"
  vpc_id      = var.vpc_id  # Ensure the correct VPC ID is passed
}

# Ingress Rules - Allow FSx Lustre traffic (port 988 and 1018-1023)
resource "aws_security_group_rule" "fsx_ingress" {
  count = var.fsx_security_group_ids == "" ? 1 : 0

  type        = "ingress"
  from_port   = 988
  to_port     = 988
  protocol    = "tcp"
  cidr_blocks = [data.aws_vpc.example.cidr_block]
  security_group_id = aws_security_group.fsx_sg[0].id

  description = "Allow FSx Lustre traffic on port 988"
}

resource "aws_security_group_rule" "fsx_ingress_1018_1023" {
  count = var.fsx_security_group_ids == "" ? 1 : 0

  type        = "ingress"
  from_port   = 1018
  to_port     = 1023
  protocol    = "tcp"
  cidr_blocks = [data.aws_vpc.example.cidr_block]
  security_group_id = aws_security_group.fsx_sg[0].id

  description = "Allow FSx Lustre traffic on ports 1018-1023"
}

# Default Egress Rule - Allow all outbound traffic (recommended for most use cases)
resource "aws_security_group_rule" "fsx_egress" {
  count = var.fsx_security_group_ids == "" ? 1 : 0

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.fsx_sg[0].id

  description = "Allow all outbound traffic"
}

# resource "aws_security_group_rule" "fsx_ingress_existing" {
#   count = var.fsx_security_group_ids != "" ? 1 : 0

#   type                 = "ingress"
#   from_port            = 988
#   to_port              = 988
#   protocol             = "tcp"
#   security_group_id    = var.fsx_security_group_ids
#   description          = "Allow FSx Lustre traffic on port 988 from existing SG"
# }

# resource "aws_security_group_rule" "fsx_ingress_1018_1023_existing" {
#   count = var.fsx_security_group_ids != "" ? 1 : 0

#   type                 = "ingress"
#   from_port            = 1018
#   to_port              = 1023
#   protocol             = "tcp"
#   security_group_id    = var.fsx_security_group_ids
#   description          = "Allow FSx Lustre traffic on ports 1018-1023 from existing SG"
# }

# resource "aws_security_group_rule" "fsx_egress_existing" {
#   count = var.fsx_security_group_ids != "" ? 1 : 0

#   type                 = "egress"
#   from_port            = 0
#   to_port              = 0
#   protocol             = "-1"
#   security_group_id    = var.fsx_security_group_ids
#   description          = "Allow all outbound traffic from existing SG"
# }
