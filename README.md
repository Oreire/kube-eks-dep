# kube-eks-dep
## Automated Deployment of Containerized Web Application on AWS EKS Using Terraform and GitHub Actions


I developed a fully automated infrastructure delivery pipeline using GitHub Actions and Terraform to provision and decommission Kubernetes environments on Amazon EKS. The workflow is structured into modular stages—VPC creation, EKS cluster deployment, application rollout, and conditional teardown—ensuring each layer is independently validated and auditable.

The process begins with provisioning a custom VPC via Terraform, with state managed remotely in an S3 backend for consistency and collaboration. This VPC includes public subnets that serve as the network foundation for the Amazon EKS cluster. In the next stage, a fully managed EKS control plane and node group are deployed using only Terraform core resources, enabling fine-grained control over IAM roles, subnet associations, and scaling parameters—without relying on third-party modules.

Once the cluster is operational, the workflow installs kubectl, updates the local kubeconfig, and verifies context authentication and node readiness. It proceeds to deploy Kubernetes manifests—including a Deployment and Service—into a designated namespace. Post-deployment checks validate LoadBalancer endpoint assignment and monitor rollout progress to confirm application stability.

To support cost-effective, short-lived test environments, I implemented a conditional teardown stage gated by a manual workflow_dispatch input (auto_destroy=true). This final phase introduces a brief delay before safely destroying the EKS cluster and VPC via Terraform, offering flexibility for ephemeral environments or controlled cleanup.

This project demonstrates proficiency in cloud-native tooling and DevOps principles, highlighting my expertise in AWS IAM, Terraform-based infrastructure-as-code, Kubernetes deployment pipelines, and GitHub Actions for CI/CD automation—all wrapped in a secure, observable, and declarative workflow.


**LoadBalancer Endpoint for Web Application Access is available at:** http://a112b036067094434803b3a363dee8fd-848965654.eu-west-2.elb.amazonaws.com
