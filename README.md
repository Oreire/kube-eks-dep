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
        "logs:CreateLogGroup",
        "logs:PutRetentionPolicy",
        "logs:TagResource"
      ],
      "Resource": "*"
    }
  ]
}

  cleanup-infra:
    name: 🧹 Destroy VPC and EKS After 5 Minutes
    needs: [deploy-vpc, deploy-eks]  # adjust job names if needed
    runs-on: ubuntu-latest
    timeout-minutes: 15

    steps:
      - name: ⏳ Wait for 5 minutes
        run: sleep 300

      - name: ⬇️ Checkout Code
        uses: actions/checkout@v3

      - name: 🔐 Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: eu-west-2

      - name: ⚙️ Setup Terraform
        uses: hashicorp/setup-terraform@v2

      - name: 💥 Destroy EKS
        working-directory: ClusterNet  # Adjust if your EKS module is elsewhere
        run: terraform destroy -auto-approve -var-file=eks.tfvars

      - name: 💥 Destroy VPC
        working-directory: KubeNet
        run: terraform destroy -auto-approve -var-file=kub.tfvars

