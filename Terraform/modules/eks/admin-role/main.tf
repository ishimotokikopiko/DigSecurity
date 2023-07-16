variable "aws_account" {type=string}
variable "name" {type=string}

# Iam role to manage eks clusters.
resource "admin_iam_role" "eks-admin" {
    name=var.name

    # Allow ec2 instances and users to assume the role.
    assume_role_policy = <<-POLICY
        {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Action": "sts:AssumeRole"
                    "Principal": {"Service": "ec2.amazonaws.com"}
                },
                {
                    "Effect": "Allow",
                    "Action": "sts:AssumeRole"
                    "Principal": {"AWS": "arn:aws:iam::${var.aws_account}:root"}
                }
            ]
        }
        POLICY
}


# Outputs
output "name" {value=aws_iam_role.eks-admin.name}
output "arn" {value=aws_iam_role.eks-admin.arn}