terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket               = "hcp-vault-demo-terraform-state"
    key                  = "terraform/aws/terraform.tfstate"
    region               = "us-east-1"
    workspace_key_prefix = "terraform/workspaces"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region_1
}

provider "aws" {
  alias  = "region2"
  region = var.aws_region_2
}

provider "aws" {
  alias  = "region3"
  region = var.aws_region_3
}

provider "aws" {
  alias  = "region4"
  region = var.aws_region_4
}

provider "aws" {
  alias  = "region5"
  region = var.aws_region_5
}

provider "aws" {
  alias  = "region6"
  region = var.aws_region_6
}
