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
        "iam:PassRole",
        "iam:ListInstanceProfilesForRole",
        "eks:CreateCluster",
        "eks:DeleteCluster",
        "eks:DescribeCluster",
        "eks:ListClusters",
        "eks:CreateNodegroup",
        "eks:DescribeNodegroup",
        "eks:DeleteNodegroup",
        "eks:TagResource",
        "eks:UntagResource",
        "logs:CreateLogGroup",
        "logs:PutRetentionPolicy",
        "logs:TagResource",
        "logs:ListTagsForResource",
        "kms:CreateKey",
        "kms:EnableKey",
        "kms:TagResource",
        "kms:CreateAlias",
        "kms:DeleteAlias",
        "kms:ListAliases",
        "iam:CreateOpenIDConnectProvider",
        "iam:TagOpenIDConnectProvider",
        "iam:GetOpenIDConnectProvider",
        "iam:DeleteOpenIDConnectProvider"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "iam:CreateServiceLinkedRole",
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "iam:AWSServiceName": [
            "eks.amazonaws.com",
            "eks-nodegroup.amazonaws.com"
          ]
        }
      }
    }
  ]
}
















WORK DONE
Fantastic. Let’s recap and set you up for success going forward:

---

### ✅ Final Infrastructure Fixes You’ve Completed
- **IAM Permissions**: You incrementally added all required actions (IAM, EKS, KMS, CloudWatch) to your user’s policy.
- **CloudWatch Log Group Conflict**: You deleted the pre-existing log group that was blocking Terraform.
- **Manual Lifecycle Management**: You now have full control over your CloudWatch logs via a dedicated Terraform resource.
- **Terraform Apply Progress**: You're nearly at a clean run—all major blockers have been resolved.

---

### 🔧 What You Might Do Next

1. **Run `terraform apply` again**  
   With the log group deleted and IAM policy updated, this apply should finally spin up your EKS cluster and supporting infra.

2. **Stabilize Long-Term with a CI/CD Role**  
   Instead of running Terraform as a user, consider creating a dedicated IAM role with a trust policy for GitHub Actions or automation tools. It'll boost security and consistency.

3. **Scope Down IAM Policy**  
   Now that you’ve mapped what Terraform really needs, we could tighten your policy by:
   - Restricting actions to specific ARNs
   - Using tag conditions
   - Segmenting by service

4. **Add Output Validations**  
   You can add sanity-check outputs (e.g., EKS cluster status, VPC ID, log group retention) to confirm everything provisioned cleanly.

---

Would you like to:
- Generate that IAM execution role?
- Tighten the policy now?
- Or go full GitOps and prep this for a PR into your infra repo?

Wherever you're headed, I’m ready to blueprint it with you.
