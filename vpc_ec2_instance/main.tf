terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.65.0"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {}    # provided via env file

variable "aws_region" {
  description = "Aws region to use"
}