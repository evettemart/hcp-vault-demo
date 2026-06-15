# HCP Vault Demo (AWS)

This demo creates the topology shown in your diagram using two Terraform stacks:

- `terraform/aws`
- `terraform/hcp-vault-aws/vault-cluster`

The implementation is based on the structure and patterns in `vault-hcp-dedicated-migration/terraform/aws` and `vault-hcp-dedicated-migration/terraform/hcp-vault-aws`.

## Topology

Vault cluster architecture (Prod AWS):

![HCP Vault Cluster Architecture](docs/hcp-vault-AWS.jpg)

Transit gateway architecture:

![HCP Vault AWS Transit Gateway](docs/hcp-vault-aws-transit-gateway.jpeg)

Non-prod architecture:

![HCP Vault AWS Non-Prod Architecture](docs/hcp-vault-AWS-non-prod.png)

### AWS + Transit Gateway + HCP Vault (Logical)

```mermaid
flowchart LR
	subgraph R1[eu-west-1]
		VPC1[AWS VPC r1\n10.20.0.0/16]
		TGW1[Transit Gateway r1]
		HVN1[HCP HVN r1 primary\n172.25.16.0/20]
		HVN1DR[HCP HVN r1 DR-for-r3\n172.30.16.0/20]
		VC1[Vault cluster r1 primary]
	end

	subgraph R2[us-east-1]
		VPC2[AWS VPC r2\n10.21.0.0/16]
		TGW2[Transit Gateway r2]
		HVN2[HCP HVN r2 primary\n172.26.16.0/20]
		HVN2DR[HCP HVN r2 DR-for-r1\n172.28.16.0/20]
		VC2[Vault cluster r2 primary]
	end

	subgraph R3[ap-southeast-1]
		VPC3[AWS VPC r3\n10.22.0.0/16]
		TGW3[Transit Gateway r3]
		HVN3[HCP HVN r3 primary\n172.27.16.0/20]
		HVN3DR[HCP HVN r3 DR-for-r2\n172.29.16.0/20]
		VC3[Vault cluster r3 primary]
	end

	VPC1 <-- VPC attachment --> TGW1
	VPC2 <-- VPC attachment --> TGW2
	VPC3 <-- VPC attachment --> TGW3

	TGW1 <-- HCP TGW attachment --> HVN1
	TGW1 <-- HCP TGW attachment --> HVN1DR
	TGW2 <-- HCP TGW attachment --> HVN2
	TGW2 <-- HCP TGW attachment --> HVN2DR
	TGW3 <-- HCP TGW attachment --> HVN3
	TGW3 <-- HCP TGW attachment --> HVN3DR

	HVN1 --> VC1
	HVN2 --> VC2
	HVN3 --> VC3

	VC1 -. performance replication .-> VC2
	VC2 -. performance replication .-> VC3
```

## Region Mapping

| System | Region Group | Platform Region | HCP Region |
|---|---|---|---|
| AWS | Group 1 | eu-west-1 (Ireland) | eu-west-1 (Ireland) |
| AWS | Group 2 | us-east-1 (N. Virginia) | us-east-1 (N. Virginia) |
| AWS | Group 3 | ap-southeast-1 (Singapore) | ap-southeast-1 (Singapore) |
| Azure | Group 1 | east-us | westeurope |
| Azure | Group 2 | central-India | eastus |
| Azure | Group 3 | west-us | southeastasia |

### `terraform/aws`

- AWS VPC, subnets, route tables, and internet gateway
- One AWS Transit Gateway per region
- VPC attachments for each regional VPC
- RAM shares for each regional Transit Gateway
- Optional acceptance of HCP Transit Gateway attachment requests
- Routes from AWS route tables to all HVN CIDRs via Transit Gateway

### `terraform/hcp-vault-aws/vault-cluster`

- Scenario-based deployment via `topology_scenario` with two architecture profiles:
- `full` (prod AWS): configured across regions 1, 2, and 3 with 3 performance-replication Vault clusters and 3 DR clusters (see manual DR section below).
- `dr_pair_r1_r2` (non-prod AWS): configured across regions 1 and 2 with 1 Vault cluster (region 1) and 1 DR path/HVN (region 2).
- Optional HVN peering controlled by `enable_hvn_peering` (default `true`)
- When `enable_hvn_peering = true`, HCP Transit Gateway attachments are created for active HVNs in the selected scenario
- When `enable_hvn_peering = true`, HVN routes are created from active HVNs back to matching AWS regional VPCs via Transit Gateway

## Folder Layout

- `terraform/aws/main.tf`
- `terraform/aws/variables.tf`
- `terraform/aws/outputs.tf`
- `terraform/aws/versions.tf`
- `terraform/aws/data.tf`
- `terraform/aws/terraform.tfvars.example`
- `terraform/hcp-vault-aws/vault-cluster/main.tf`
- `terraform/hcp-vault-aws/vault-cluster/variables.tf`
- `terraform/hcp-vault-aws/vault-cluster/outputs.tf`
- `terraform/hcp-vault-aws/vault-cluster/versions.tf`
- `terraform/hcp-vault-aws/vault-cluster/terraform.tfvars.example`

## Prerequisites

1. Make a copy of `.env.example` and populate your AWS values.
2. Login into HCP.
3. Create a project, for example `hcp-vault-aws-prod`.
4. Get the `hcp-project-id` and populate your `.env` file.
5. Create a service account with admin access to the project.
6. Add `HCP_CLIENT_ID` and `HCP_CLIENT_SECRET` to your `.env` file.

Before running Terraform commands, source the environment file:

```bash
source .env
```

Create workspace-specific tfvars files in both stack directories:

```bash
cp terraform/aws/terraform.tfvars.example terraform/aws/non-prod.tfvars
cp terraform/aws/terraform.tfvars.example terraform/aws/prod.tfvars

cp terraform/hcp-vault-aws/vault-cluster/terraform.tfvars.example terraform/hcp-vault-aws/vault-cluster/non-prod.tfvars
cp terraform/hcp-vault-aws/vault-cluster/terraform.tfvars.example terraform/hcp-vault-aws/vault-cluster/prod.tfvars
```

Set different HCP project IDs per environment:

- `terraform/hcp-vault-aws/vault-cluster/non-prod.tfvars` -> non-prod HCP project ID
- `terraform/hcp-vault-aws/vault-cluster/prod.tfvars` -> prod HCP project ID

Example:

```hcl
# non-prod.tfvars
project_id = "<hcp-non-prod-project-id>"
topology_scenario = "dr_pair_r1_r2"

# prod.tfvars
project_id = "<hcp-prod-project-id>"
topology_scenario = "full"
# Prod uses regions 1, 2, and 3.
```

## Deployment Order

1. Create the Terraform state S3 bucket (run once per environment).
2. Create/select Terraform workspace (`non-prod` or `prod`) in both stacks.
3. Deploy AWS network + Transit Gateways + RAM shares using workspace tfvars.
4. Set HCP provider AWS account IDs in workspace tfvars and re-apply AWS.
5. If `enable_hvn_peering = true`, copy AWS output values (TGW IDs, TGW share ARNs, VPC CIDRs) into `terraform/hcp-vault-aws/vault-cluster/<workspace>.tfvars`.
6. Deploy HCP Vault stack using the matching workspace tfvars (with matching HCP project ID).
7. Accept pending Transit Gateway attachments in AWS (if not auto-accepted).
8. Enable `enable_hcp_tgw_acceptance = true` in AWS workspace tfvars and apply AWS.
9. Re-run plans for both stacks and confirm no changes.

## Commands

```bash
# 1) Load environment variables
source .env

# 2) One-time setup: create Terraform state bucket (run once)
./scripts/create_s3_bucket.sh <globally-unique-bucket-name> <region>

# 3) Create workspace tfvars
cp terraform/aws/terraform.tfvars.example terraform/aws/non-prod.tfvars
cp terraform/aws/terraform.tfvars.example terraform/aws/prod.tfvars
cp terraform/hcp-vault-aws/vault-cluster/terraform.tfvars.example terraform/hcp-vault-aws/vault-cluster/non-prod.tfvars
cp terraform/hcp-vault-aws/vault-cluster/terraform.tfvars.example terraform/hcp-vault-aws/vault-cluster/prod.tfvars

# 4) Choose environment
export TF_ENV=non-prod   # or prod

# 5) AWS stack: init + workspace
terraform -chdir=terraform/aws init -reconfigure
terraform -chdir=terraform/aws workspace new "$TF_ENV" || terraform -chdir=terraform/aws workspace select "$TF_ENV"
terraform -chdir=terraform/aws workspace show

# 6) AWS network apply with workspace tfvars
terraform -chdir=terraform/aws plan  -var-file="$TF_ENV.tfvars"
terraform -chdir=terraform/aws apply -var-file="$TF_ENV.tfvars"

# 7) Set HCP provider account IDs in terraform/aws/$TF_ENV.tfvars
# Example (same account ID may be used across all regions):
# hcp_provider_account_id_region_1 = "<hcp-provider-account-id>"
# hcp_provider_account_id_region_2 = "<hcp-provider-account-id>"
# hcp_provider_account_id_region_3 = "<hcp-provider-account-id>"

# 8) Re-apply AWS to create RAM principal associations
terraform -chdir=terraform/aws apply -var-file="$TF_ENV.tfvars"

# 9) If enable_hvn_peering=true, capture AWS outputs and set these values in terraform/hcp-vault-aws/vault-cluster/$TF_ENV.tfvars:
# aws_tgw_region_1_id, aws_tgw_region_2_id, aws_tgw_region_3_id
# aws_tgw_region_1_share_arn, aws_tgw_region_2_share_arn, aws_tgw_region_3_share_arn
# aws_vpc_region_1_cidr_block, aws_vpc_region_2_cidr_block, aws_vpc_region_3_cidr_block
terraform -chdir=terraform/aws output tgw_region_1_id
terraform -chdir=terraform/aws output tgw_region_2_id
terraform -chdir=terraform/aws output tgw_region_3_id
terraform -chdir=terraform/aws output tgw_region_1_share_arn
terraform -chdir=terraform/aws output tgw_region_2_share_arn
terraform -chdir=terraform/aws output tgw_region_3_share_arn
terraform -chdir=terraform/aws output vpc_region_1_cidr_block
terraform -chdir=terraform/aws output vpc_region_2_cidr_block
terraform -chdir=terraform/aws output vpc_region_3_cidr_block

# 10) HCP stack: init + same workspace
terraform -chdir=terraform/hcp-vault-aws/vault-cluster init -reconfigure
terraform -chdir=terraform/hcp-vault-aws/vault-cluster workspace new "$TF_ENV" || terraform -chdir=terraform/hcp-vault-aws/vault-cluster workspace select "$TF_ENV"
terraform -chdir=terraform/hcp-vault-aws/vault-cluster workspace show

# 11) HCP Vault on AWS using matching workspace tfvars
terraform -chdir=terraform/hcp-vault-aws/vault-cluster plan  -var-file="$TF_ENV.tfvars"
terraform -chdir=terraform/hcp-vault-aws/vault-cluster apply -var-file="$TF_ENV.tfvars"

# 12) Accept pending Transit Gateway attachments in AWS Console if needed
# VPC/EC2 -> Transit Gateways -> Transit Gateway Attachments -> Accept

# 13) Enable acceptance in terraform/aws/$TF_ENV.tfvars and apply:
# enable_hcp_tgw_acceptance = true
terraform -chdir=terraform/aws apply -var-file="$TF_ENV.tfvars"

# 14) Final convergence check (same workspace)
terraform -chdir=terraform/aws plan -var-file="$TF_ENV.tfvars"
terraform -chdir=terraform/hcp-vault-aws/vault-cluster plan -var-file="$TF_ENV.tfvars"
```

Important workspace notes:

- Do not use the `default` workspace for environment deployments.
- Use the same workspace name in both stacks (`non-prod` with `non-prod`, `prod` with `prod`).
- Backends are configured with workspace-isolated S3 paths via `workspace_key_prefix`.

## Transit Gateway Notes

- Transit Gateway is regional; this demo creates one TGW per region (`eu-west-1`, `us-east-1`, `ap-southeast-1`).
- In `full` topology, each region typically shows 3 TGW attachments:
	- 1 AWS VPC attachment
	- 2 HCP-managed attachments (primary + DR HVN in that region)
- In `dr_pair_r1_r2` non-prod topology, regions 1 and 2 typically show 2 TGW attachments each:
	- 1 AWS VPC attachment
	- 1 HCP-managed attachment
- If HCP apply returns `resource share doesn't exist in the cloud provider`, ensure
	`hcp_provider_account_id_region_1/2/3` are set in `terraform/aws/<workspace>.tfvars`
	and AWS stack has been re-applied to create RAM principal associations.

## GitHub Actions (On-Demand)

Two separate manual workflows are included:

- `.github/workflows/deploy-aws.yml`
- `.github/workflows/deploy-hcp-vault-cluster.yml`

These workflows run only when manually triggered (`workflow_dispatch`) from the GitHub Actions tab.

Required repository secrets:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION`
- `HCP_CLIENT_ID`
- `HCP_CLIENT_SECRET`

Workflow behavior:

- Both workflows require a `workspace` input (`non-prod` by default, or `prod`).
- Both workflows select the provided workspace and run with `-var-file=<workspace>.tfvars`.

Make sure these files exist and are populated for the workspace you select:

- `terraform/aws/non-prod.tfvars` and `terraform/hcp-vault-aws/vault-cluster/non-prod.tfvars`
- `terraform/aws/prod.tfvars` and `terraform/hcp-vault-aws/vault-cluster/prod.tfvars`

How to run:

1. Open **GitHub -> Actions**.
2. Select either **Deploy AWS** or **Deploy HCP Vault Cluster**.
3. Click **Run workflow**.
4. Choose `workspace` (`non-prod` or `prod`).
5. Set `apply` to `false` to run plan only.
6. Set `apply` to `true` to run plan and apply.

## Manual DR Cluster Setup (HCP Console)

For `prod` (`topology_scenario = "full"`), after Terraform is complete, create DR clusters manually in the HCP console.
This produces the three DR clusters expected for the prod architecture.

Guidance:
https://developer.hashicorp.com/vault/tutorials/get-started-hcp-vault-dedicated/manage-clusters#create-cluster-with-cross-region-dr

Select the backup network (HVN) as follows:

| Primary Cluster | Primary Region | Backup Network (HVN) | Backup Region |
|---|---|---|---|
| `vault-r1-primary` | eu-west-1 | `vault-r2-dr-for-r1-hvn` | us-east-1 |
| `vault-r2-primary` | us-east-1 | `vault-r3-dr-for-r2-hvn` | ap-southeast-1 |
| `vault-r3-primary` | ap-southeast-1 | `vault-r1-dr-for-r3-hvn` | eu-west-1 |

## Required Environment Variables

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION`
- `HCP_CLIENT_ID`
- `HCP_CLIENT_SECRET`

Optional for HCP Vault provider operations outside this scaffold:

- `VAULT_ADDR`
- `VAULT_TOKEN`