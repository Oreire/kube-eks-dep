# kube-eks-dep

# 🚀 Automated Deployment of Containerized Web Application on AWS EKS Using Terraform and GitHub Actions


## 📌 Project Overview

**Designed and deployed a secure, fully automated CI/CD pipeline for containerized applications on Amazon EKS using Terraform and GitHub Actions, showcasing infrastructure-as-code and cloud-native deployment expertise.** This project automates the provisioning and teardown of Kubernetes infrastructure on AWS EKS through a modular, GitOps-based workflow. It delivers containerized web applications in a secure, repeatable, scalable, and declarative environment, emphasizing stateless CI pipelines, guarded teardown inputs, and infrastructure governance. By combining IaC principles with Kubernetes automation, the resulting pipeline supports both ephemeral testing and long-lived environments with balanced flexibility and control. The project demonstrates proficiency in cloud-native tooling and DevOps principles, highlighting my expertise in AWS IAM, Terraform-based infrastructure-as-code, Kubernetes deployment pipelines, and GitHub Actions for CI/CD automation—all wrapped in a secure, observable, and declarative workflow.


## 🛠 Architecture Highlights

- **Custom VPC with public subnets** for EKS node placement

- **Amazon EKS cluster** with managed control plane and autoscaling node group

- **GitHub Actions CI/CD pipeline** orchestrating:

  - VPC & EKS provisioning via Terraform

  - Kubernetes deployment using `kubectl`

  - Teardown stage for ephemeral environments (Optional)



## 🔁 Workflow Stages

1. **Provision Infrastructure**

   - VPC → EKS Cluster → Node Group

   - Terraform state managed in S3 with DynamoDB locking

2. **Deploy Application**

   - Kubernetes manifests applied to cluster

   - Application exposed via LoadBalancer service

3. **Validate Deployment**

   - Node readiness and load balancer endpoint verification

4. **Optional Teardown**

   - Triggered via workflow dispatch (`auto_destroy=true`)

   - Destroys all resources cleanly with delay and audit



## 💡 Key Features

    - Modular Terraform structure

    - Remote state backend and locking

    - Secure IAM role usage

    - Manual teardown approval for cost control

    - Ready for ArgoCD, Prometheus, and GitOps enhancements



## 🔗 Live Demo

## LoadBalancer Endpoint for Web Application Access is available at:** ` http://aa2c3f8c5514e4d4e86316ff92273386-1005030420.eu-west-2.elb.amazonaws.com`  _(Test URL subject to TTL teardown)_


Production-Grade Relevance

  ------------------------------------------------------------------------------------
  |  **Feature**	          |     **Production Benefit**                            |
  ------------------------------------------------------------------------------------
  | Remote state (S3 + lock)  |	Prevents state corruption, enables collaboration      |
  ------------------------------------------------------------------------------------
  | Multi-AZ cluster	      | Higher availability and resilience to failures        |
  ------------------------------------------------------------------------------------
  | Managed node groups	      | Integrated patching and auto-scaling                  |
  ------------------------------------------------------------------------------------
  | GitOps pipeline	          | Repeatable, auditable, and version-controlled infra   |
  ------------------------------------------------------------------------------------
  | Kubernetes LoadBalancer	  | Built-in auto-scaling and fault tolerance via AWS ELB |
  ------------------------------------------------------------------------------------
  | IAM + Network Security	  | Least-privilege, encrypted communication              |
  ------------------------------------------------------------------------------------



## 🧠 Lessons Learned

    - Importance of IAM granularity and trust boundaries
    - Debugging node bootstrap via subnet and IAM validation
    - Risks of resource orphaning and teardown dependencies
    - CI/CD resilience through gating and lifecycle decoupling


## 📈 Next Enhancements

    - Integrate ArgoCD and Kustomize overlays
    - Add Fluent Bit + Prometheus for observability
    - Harden public exposure with Ingress, WAF, and NetworkPolicies
    - Automate environment promotion via release tags

