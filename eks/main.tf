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
  }

  required_version = ">= 0.14.9"
}

provider "aws" {}    # provided via env file

variable "aws_region" { 
  # provided via env file
  description = "Aws region to use"
}

variable "aws_account" { 
  # provided via env file
  description = "Aws account to use"
}