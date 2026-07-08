terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket               = "hcp-vault-demo-terraform-state"
    key                  = "terraform/hcp-vault-aws/vault-cluster/terraform.tfstate"
    region               = "us-east-1"
    workspace_key_prefix = "terraform/workspaces"
  }

  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.100"
    }
  }
}

provider "hcp" {
  project_id = var.project_id
}
