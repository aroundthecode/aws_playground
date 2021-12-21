terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.65.0"
    }
    local = {
      source = "hashicorp/local"
      version = "2.1.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.7.1"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.4.1"
    }
    tls = {
      source = "hashicorp/tls"
      version = "3.1.0"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {}    # provided via env file

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
}

variable "aws_region" { 
  # provided via env file
  description = "Aws region to use"
}

variable "aws_account" { 
  # provided via env file
  description = "Aws account to use"
}