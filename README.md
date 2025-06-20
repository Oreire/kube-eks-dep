# kube-eks-dep
Deployment of Containerized Web Application on AWS EKS Using Terraform and GitHub Actions
updated policy to allo the effective creation of eks clustyer and associated services:

{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:CreateRole",
        "iam:AttachRolePolicy",
        "iam:PutRolePolicy",
        "iam:CreatePolicy",
        "iam:DeletePolicy",
        "iam:GetRole",
        "iam:GetPolicy",
        "iam:GetPolicyVersion",
        "iam:ListRolePolicies",
        "iam:ListAttachedRolePolicies",
        "iam:ListPolicyVersions",
        "iam:TagRole",
        "eks:CreateCluster",
        "eks:DeleteCluster",
        "logs:CreateLogGroup",
        "logs:PutRetentionPolicy",
        "logs:TagResource",
        "logs:ListTagsForResource",
        "kms:CreateKey",
        "kms:EnableKey",
        "kms:TagResource",
        "kms:CreateAlias",
        "kms:DeleteAlias",
        "kms:ListAliases"
      ],
      "Resource": "*"
    }
  ]
}



"eks:CreateCluster",
"kms:DeleteAlias",
"kms:DeleteAlias"


