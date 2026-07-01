terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket               = "hcp-vault-demo-terraform-state"
    key                  = "terraform/hcp-vault-aws/vault-bootstrap/terraform.tfstate"
    region               = "us-east-1"
    workspace_key_prefix = "terraform/workspaces"
  }

  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.8"
    }
  }
}

provider "vault" {
  address = var.vault_addr
  token   = var.vault_token
}

provider "vault" {
  alias     = "admin"
  address   = var.vault_addr
  token     = var.vault_token
  namespace = var.admin_namespace
}
