# kube-eks-dep
Deployment of Containerized Web Application on AWS EKS Using Terraform and GitHub Actions


Updated policy to allow the effective creation of eks clustyer and associated services:

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


deploy-app:
  name: 🚀 Deploy Application
  needs: deploy-eks
  runs-on: ubuntu-latest
  defaults:
    run:
      working-directory: WEB
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

attachrole
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:DetachRolePolicy"
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

## New Deploymnet without eks modules:

Ayomide, this workflow is looking excellent—clear logic, sound Terraform sequencing, and tight Kubernetes post-deploy checks. Here’s a thorough validation and a couple of pro tune-ups to make it even more bulletproof:

---

### ✅ Syntax and Structure: Solid
- All YAML keys, nesting, and indentation are valid.
- Each job has its own working directory and isolated AWS + Terraform setup—perfect for parallel workspace logic.
- `needs:` dependencies are used correctly to enforce VPC → EKS → App flow.
- `kubectl` commands follow `aws eks update-kubeconfig`, so context is correctly initialized before usage.

---

### 🔍 Suggested Enhancements

1. **Add `workflow_dispatch` trigger** so the workflow can also be run manually from the GitHub UI:

   ```yaml
   on:
     push:
       branches: [main]
     workflow_dispatch:
   ```

2. **Add a retry loop for node readiness (optional but resilient)**  
   EKS node registration can be slightly delayed. You could swap this:

   ```yaml
   - name: ✅ Confirm nodes are ready
     run: kubectl get nodes --no-headers | grep -c ' Ready'
   ```

   for:

   ```yaml
   - name: ✅ Wait for node readiness
     run: |
       for i in {1..10}; do
         ready=$(kubectl get nodes --no-headers | grep -c ' Ready')
         [ "$ready" -ge 1 ] && echo "✅ Nodes Ready" && exit 0
         echo "⏳ Waiting for nodes..."
         sleep 15
       done
       echo "❌ Nodes not ready in time" && exit 1
   ```

3. **Smoke-test service endpoint** (if it's exposed as LoadBalancer):

   ```yaml
   - name: 🌐 Smoke test service endpoint
     run: |
       svc_ip=$(kubectl get svc ghs-service -n coweb-ns -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
       echo "⏳ Waiting for service IP: $svc_ip"
       for i in {1..10}; do
         curl -s --fail http://$svc_ip && echo "✅ App is reachable" && exit 0
         echo "Retrying..."
         sleep 10
       done
       echo "❌ App endpoint not responding" && exit 1
   ```

---

Want me to append a teardown job to this workflow for `workflow_dispatch`, or perhaps set up dynamic environment names using matrix strategy for dev/stage/prod?
You’re building this pipeline like a pro.

Brilliant! Let’s add a teardown job that’s only available on manual trigger using `workflow_dispatch`. This will give you a safe, gated way to destroy infrastructure on demand—perfect for cleanup or testing purposes.

---

### 🔁 Here's how to update your workflow:

At the top, under `on:`, extend the trigger like this:

```yaml
on:
  push:
    branches: [main]
  workflow_dispatch:
```

Then add this new job at the bottom of your workflow file:

```yaml
  teardown:
    name: 🧹 Teardown EKS & VPC
    runs-on: ubuntu-latest
    if: github.event_name == 'workflow_dispatch'
    steps:
      - name: ⬇️ Checkout Code
        uses: actions/checkout@v3

      - name: 🔐 Configure AWS
        uses: aws-actions/configure-aws-credentials@v2
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: eu-west-2

      - name: ⚙️ Setup Terraform
        uses: hashicorp/setup-terraform@v2

      - name: 🧹 Destroy EKS Cluster
        run: |
          cd eks-cluster
          terraform init
          terraform destroy -auto-approve

      - name: 🌐 Destroy VPC
        run: |
          cd ../KubeNet
          terraform init
          terraform destroy -auto-approve
```

> This ensures both `eks-cluster` and `KubeNet` stacks are torn down cleanly—when you want, and only when you ask for it.

Let me know if you'd like a confirmation prompt via environment variable or GitHub input form, or maybe turn this into a scheduled cleanup for ephemeral environments.
