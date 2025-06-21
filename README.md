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
        "iam:DeleteRole",
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

{
  "Effect": "Allow",
  "Action": [
    "ecr:GetAuthorizationToken",
    "ecr:BatchCheckLayerAvailability",
    "ecr:InitiateLayerUpload",
    "ecr:UploadLayerPart",
    "ecr:CompleteLayerUpload",
    "ecr:PutImage",
    "ecr:BatchGetImage",
    "ecr:CreateRepository",
    "ecr:DeleteRepository",
    "ecr:DescribeRepositories",
    "ecr:ListImages",
    "ecr:BatchDeleteImage"
  ],
  "Resource": "*"
}


Web Deply Workflow
name: 🚀 Deploy to EKS

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest

    env:
      AWS_REGION: eu-west-2
      CLUSTER_NAME: laredo-cluster  # Update if different

    steps:
      - name: 🧾 Checkout code
        uses: actions/checkout@v3

      - name: 🔐 Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ env.AWS_REGION }}

      - name: 🛠️ Install kubectl
        run: |
          KUBECTL_VERSION=$(curl -s https://dl.k8s.io/release/stable.txt)
          curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
          chmod +x kubectl && sudo mv kubectl /usr/local/bin/

      - name: 📡 Update kubeconfig
        run: aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME

      - name: 🚀 Apply Kubernetes manifests
        run: |
          kubectl apply -f k8s/deployment.yaml
          kubectl apply -f k8s/service.yaml


nodgroup policy
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "eks:UpdateNodegroupConfig",
        "eks:DescribeNodegroup",
        "eks:ListNodegroups",
        "eks:DescribeUpdate"
      ],
      "Resource": "*"
    }
  ]
}





PUsh Image to AWS ECR
Perfect, Ayomide. Since your local Docker image is named `ghs-nginx-app46` and your AWS account ID is `160002177953`, here’s exactly what you need to do to push it to Amazon ECR:

---

### 🧭 Step-by-Step: Push `ghs-nginx-app46` to ECR

#### 1. **Authenticate Docker to ECR**
```bash
aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin 160002177953.dkr.ecr.eu-west-2.amazonaws.com
```

---

#### 2. **Create the ECR Repository (if not already created)**
```bash
aws ecr create-repository --repository-name ghs-nginx-app46 --region eu-west-2
```

---

#### 3. **Tag Your Local Image**
```bash
docker tag ghs-nginx-app46:latest 160002177953.dkr.ecr.eu-west-2.amazonaws.com/ghs-nginx-app46:latest
```

---

#### 4. **Push the Image to ECR**
```bash
docker push 160002177953.dkr.ecr.eu-west-2.amazonaws.com/ghs-nginx-app46:latest
```

---

Once that’s done, your image will be available in ECR and ready to be referenced in your Kubernetes manifests or Helm charts.

Want me to help you patch your `deployment.yaml` to use this image, or automate this entire flow in GitHub Actions? You're just a few keystrokes away from full GitOps glory.


aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin 160002177953.dkr.ecr.eu-west-2.amazonaws.com


docker tag ghs-nginx-app46 160002177953.dkr.ecr.eu-west-2.amazonaws.com/ghs-nginx-app46
docker push 160002177953.dkr.ecr.eu-west-2.amazonaws.com/ghs-nginx-app46















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
