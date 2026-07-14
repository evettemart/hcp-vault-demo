# HCP Vault Demo (AWS + Azure)

This demo creates the topology shown in your diagram using two Terraform stacks.
This is a demo repository, and should be reviewed and configuration selected as per your requirements.

- `terraform/aws`
- `terraform/hcp-vault/vault-cluster`

This repository deploys HCP Vault resources and supports AWS and Azure connectivity patterns.

The implementation is based on the structure and patterns in `vault-hcp-dedicated-migration/terraform/aws` and `vault-hcp-dedicated-migration/terraform/hcp-vault-aws`.

## Topology

Vault cluster architecture (Prod AWS):

![HCP Vault Cluster Architecture](docs/hcp-vault-AWS.jpg)

Transit gateway architecture:

![HCP Vault AWS Transit Gateway](docs/hcp-vault-aws-transit-gateway.jpeg)

Non-prod architecture:

![HCP Vault AWS Non-Prod Architecture](docs/hcp-vault-AWS-non-prod.png)



## AWS Region Mapping

| Cluster | AWS Region | HCP HVN Region | Role |
|---|---|---|---|
| Region 1 / cluster_1 | ap-southeast-1 (Singapore) | ap-southeast-1 (Singapore) | Primary |
| Region 2 / cluster_2 | ap-northeast-1 (Tokyo) | ap-northeast-1 (Tokyo) | DR HVN only |
| Region 3 / cluster_3 | eu-west-1 (Ireland) | eu-west-1 (Ireland) | Secondary to cluster_1 |
| Region 4 / cluster_4 | eu-west-2 (London) | eu-west-2 (London) | DR HVN only |
| Region 5 / cluster_5 | us-east-1 (N. Virginia) | us-east-1 (N. Virginia) | Secondary to cluster_1 |
| Region 6 / cluster_6 | us-east-2 (Ohio) | us-east-2 (Ohio) | DR HVN only |

## Azure Region Mapping

| Cluster | Azure Region | HCP HVN Region | Role |
|---|---|---|---|
| Region 1 / cluster_1 | southeastasia | southeastasia | Primary |
| Region 2 / cluster_2 | japaneast | japaneast | DR HVN only |
| Region 3 / cluster_3 | northeurope | northeurope | Secondary to cluster_1 |
| Region 4 / cluster_4 | francecentral | francecentral | DR HVN only |
| Region 5 / cluster_5 | eastus | eastus | Secondary to cluster_1 |
| Region 6 / cluster_6 | centralus | centralus | DR HVN only |

Environment behavior:

- non-prod: deploys regions 1 and 2 only.
- prod: deploys regions 1, 2, 3, 4, 5, and 6.

### `terraform/aws`

- AWS VPC, subnets, route tables, and internet gateway
- One AWS Transit Gateway per region
- VPC attachments for each regional VPC
- RAM shares for each regional Transit Gateway
- Optional acceptance of HCP Transit Gateway attachment requests
- Routes from AWS route tables to all HVN CIDRs via Transit Gateway
- Optional Region 1 EC2-based Postgres and MySQL test database hosts for Vault database secret engine validation

### `terraform/hcp-vault/vault-cluster`

- Scenario-based deployment via `topology_scenario` with two architecture profiles:
- `prod`: creates Vault clusters for `cluster_1` (primary), `cluster_3` (secondary), and `cluster_5` (secondary). For `cluster_2`, `cluster_4`, and `cluster_6`, Terraform creates HVNs only; DR Vault clusters are manual.
- `non-prod`: creates `cluster_1` as the only Terraform-managed Vault cluster. The DR secondary (`cluster_2`) is created manually in HCP.
- Optional HVN peering controlled by `enable_hvn_peering` (default `true`)
- When `enable_hvn_peering = true`, HCP Transit Gateway attachments are created for active HVNs in the selected scenario
- When `enable_hvn_peering = true`, HVN routes are created from active HVNs back to matching AWS regional VPCs via Transit Gateway
- When `enable_hvn_peering = true` and `cloud_provider = "azure"`, HCP Azure peering connections are created for active HVNs
- When `enable_hvn_peering = true` and `cloud_provider = "azure"`, HVN routes are created from active HVNs to the configured Azure destination CIDRs
- `cluster_configs` is required and must be defined in environment tfvars.
- `aws_region_connectivity` is required only when `enable_hvn_peering = true`.
- `azure_region_connectivity` is required only when `enable_hvn_peering = true` and `cloud_provider = "azure"`.

Azure scope note:

- this Terraform creates HCP-side peering and HVN routes. It does not build Azure-side NVA route tables/UDRs/NVA config; those must already exist or be managed separately.

### `terraform/hcp-vault/vault-bootstrap`

- Bootstraps Vault configuration inside the admin namespace after the cluster exists.
- Creates baseline admin policies from `terraform/hcp-vault/policies/admin`.
- Enables and configures auth methods in the admin namespace.
- Creates child namespaces when enabled.
- Creates identity groups and optional external aliases for namespace onboarding.

Supported auth methods (admin namespace):

- Generic auth enables via `auth_methods`: `oidc`, `jwt`
- OIDC auth backend configuration via `oidc_auth_methods` (or legacy single-backend inputs)
- AWS auth backend configuration via `aws_auth_methods`
- Azure auth backend configuration via `azure_auth_methods`
- GCP auth backend configuration via `gcp_auth_methods`
- AppRole auth backend configuration via `approle_auth_methods`

Supported secret engines:

- Namespace stack reusable modules: KV v2 (`terraform/hcp-vault/modules/kv_v2`), SSH (`terraform/hcp-vault/modules/ssh`)
- Namespace stack engine maps (in `terraform/hcp-vault/namespace1/non-prod.tfvars`): AWS (`aws_secret_engines`), Database (`database_secret_engines`), LDAP (`ldap_secret_engines`), Kubernetes (`kubernetes_secret_engines`)

Identity group ownership and namespace mapping:

- Identity groups are managed by `terraform/hcp-vault/vault-bootstrap` via `namespace_groups`.
- Use `admin` as the key for groups in the admin namespace.
- Use child namespace keys like `namespace1` (not `admin/namespace1`) for groups in `admin/<child>` namespaces.
- The namespace stack under `terraform/hcp-vault/namespace1` currently manages policies and secret engines, not identity groups.

### `terraform/hcp-vault/namespace1` AWS secrets examples

The namespace1 non-prod example includes both AWS credential patterns:

- `iam_user` role example (`app-iam-user`):
	- `credential_type = "iam_user"`
	- `policy_document_file = "pcs/cloudaccount1/non-prod/aws-secrets-test-readonly.json"`
	- Vault creates IAM user credentials according to the supplied IAM policy document.
- `assumed_role` role example (`app-assumed-role`):
	- `credential_type = "assumed_role"`
	- `role_arns = ["arn:aws:iam::123456789012:role/app-nonprod-readonly"]`
	- Vault returns short-lived STS credentials by assuming the target IAM role.

Files:

- role examples: `terraform/hcp-vault/namespace1/non-prod.tfvars`
- IAM policy document file for `iam_user`: `terraform/hcp-vault/policies/namespace1/pcs/cloudaccount1/non-prod/aws-secrets-test-readonly.json`

Note:

- replace the placeholder role ARN with your real AWS IAM role ARN before apply.
- in `non-prod.tfvars`, keep `aws_secret_engines` commented until AWS wiring (root config and target roles) is available.

### `terraform/hcp-vault/namespace1` Database secrets examples

The namespace1 non-prod example defines two database secret engine mounts:

- `pcs/cloudaccount1/non-prod/database-postgres`
- `pcs/cloudaccount1/non-prod/database-mysql`

Each mount includes two database connections and two corresponding dynamic roles:

- Postgres mount (`database-postgres`):
	- connections: `postgres-app`, `postgres-analytics`
	- roles: `postgres-app-readonly`, `postgres-analytics-readonly`
- MySQL mount (`database-mysql`):
	- connections: `mysql-app`, `mysql-reporting`
	- roles: `mysql-app-readonly`, `mysql-reporting-readonly`

File:

- examples: `terraform/hcp-vault/namespace1/non-prod.tfvars`

Note:

- in `non-prod.tfvars`, keep `database_secret_engines` and `ldap_secret_engines` commented until backing services are available.

### AWS test databases for Vault database secret engine testing

The AWS stack can create low-cost Amazon RDS test databases in Region 1:

- PostgreSQL in Region 1 (port `5432`)
- MySQL in Region 1 (port `3306`)

Enable and configure in `terraform/aws/non-prod.tfvars`:

```hcl
enable_test_databases       = true
test_database_instance_type = "db.t4g.micro"

test_database_allowed_cidrs = [
	"10.20.0.0/24",
	"172.25.16.0/24",
	"172.28.16.0/24"
]

test_postgres_username = "vaultadmin"
test_postgres_password = "replace-me"
test_postgres_database = "appdb"

test_mysql_username      = "vaultadmin"
test_mysql_password      = "replace-me"
test_mysql_database      = "appdb"
```

Apply AWS stack and read connection outputs:

```bash
terraform -chdir=terraform/aws apply -var-file=non-prod.tfvars
terraform -chdir=terraform/aws output test_postgres_connection_host
terraform -chdir=terraform/aws output test_mysql_connection_host
```

Use these in `terraform/hcp-vault/namespace1/non-prod.tfvars` under `database_secret_engines`:

- Postgres: `allowed_roles`, `plugin_name = "postgresql-database-plugin"`, host from `test_postgres_connection_host`, port `5432`
- MySQL: `allowed_roles`, `plugin_name = "mysql-database-plugin"`, host from `test_mysql_connection_host`, port `3306`

Internal vs external group behavior:

- `group_type = "internal"`: Vault-managed membership; no AD/IdP connectivity needed.
- `group_type = "external"`: Vault group alias mapping to IdP group (`alias_name`) using `oidc_accessor`.
- External alias creation does not require live AD login, but it does require a valid OIDC mount accessor in Vault.

Testing without AD connectivity:

1. Add at least one internal group under `namespace_groups.admin` and (optionally) one under `namespace_groups.namespace1`.
2. Run `terraform -chdir=terraform/hcp-vault/vault-bootstrap plan -var-file=non-prod.tfvars`.
3. Run `terraform -chdir=terraform/hcp-vault/vault-bootstrap apply -var-file=non-prod.tfvars`.
4. Validate resources in state with:
	- `module.identity_groups["admin"].vault_identity_group.this["<group-name>"]`
	- `module.identity_groups["namespace1"].vault_identity_group.this["<group-name>"]`
5. For external alias testing, uncomment an external group, set `oidc_accessor`, and re-run plan/apply.

## Folder Layout

- `terraform/aws/main.tf`
- `terraform/aws/variables.tf`
- `terraform/aws/outputs.tf`
- `terraform/aws/versions.tf`
- `terraform/aws/data.tf`
- `terraform/aws/terraform.tfvars.example`
- `terraform/hcp-vault/vault-cluster/main.tf`
- `terraform/hcp-vault/vault-cluster/variables.tf`
- `terraform/hcp-vault/vault-cluster/outputs.tf`
- `terraform/hcp-vault/vault-cluster/versions.tf`
- `terraform/hcp-vault/vault-cluster/terraform.tfvars.example`

Namespace bootstrapping and app-team stacks are also included under `terraform/hcp-vault/`:

- `terraform/hcp-vault/vault-bootstrap/`
- `terraform/hcp-vault/namespace1/`
- `terraform/hcp-vault/modules/`
- `terraform/hcp-vault/policies/`

Auth and secret-engine modules under `terraform/hcp-vault/modules/` include:

- `oidc/`, `aws_auth/`, `azure_auth/`, `gcp_auth/`, `approle_auth/`
- `kv_v2/`, `ssh/`, `aws_secrets/`, `database_secrets/`, `ldap_secrets/`, `kubernetes_secrets/`

## Naming Conventions (Secret Engines and Policies)

Use the same path convention for secret engine mount paths and Vault policy names:

- `<namespace-team>/<cloud-account>/<environment>/<name>`

Examples:

- Secret engine mount path: `pcs/cloudaccount1/non-prod/kv-v2-test`
- Policy name (writer): `pcs/cloudaccount1/non-prod/kv-v2-test-writer`
- Policy name (consumer): `pcs/cloudaccount1/non-prod/kv-v2-test-consumer`

For namespace policy files in `terraform/hcp-vault/policies/namespace1`, nested file paths map directly to policy names.

Example file to policy mapping:

- `terraform/hcp-vault/policies/namespace1/pcs/cloudaccount1/non-prod/kv-v2-test-writer.hcl`
- policy name: `pcs/cloudaccount1/non-prod/kv-v2-test-writer`

## Namespace Stacks and Policy Folders

Each namespace should have both:

- A Terraform stack folder under `terraform/hcp-vault/<namespace>/`
- A policy folder under `terraform/hcp-vault/policies/<namespace>/`

Example for namespace1:

- Terraform stack: `terraform/hcp-vault/namespace1/`
- Policy folder: `terraform/hcp-vault/policies/namespace1/`

The namespace stack applies all policy files from its configured policy folder. Nested policy files are supported, and the relative file path (without `.hcl`) becomes the Vault policy name.

Example:

- `terraform/hcp-vault/policies/namespace1/pcs/cloudaccount1/non-prod/kv-v2-test-consumer.hcl`
- policy name: `pcs/cloudaccount1/non-prod/kv-v2-test-consumer`

When creating a new namespace:

1. Create `terraform/hcp-vault/<namespace>/` by copying the namespace stack pattern.
2. Create `terraform/hcp-vault/policies/<namespace>/`.
3. Add secret engines using mount paths in format `<namespace-team>/<cloud-account>/<environment>/<name>`.
4. Add policies in nested folders so policy names follow the same format.

## KV v2 Module Behavior

The reusable KV module at `terraform/hcp-vault/modules/kv_v2`:

- mounts a KV v2 secrets engine
- configures KV v2 options (max versions, CAS, delete window in seconds)
- can generate per-user policies from team/member mappings

Policy model for generated member policies:

- `<mount>/data/<team>/<member>/*` with create/update/patch/read/delete
- `<mount>/metadata/<team>/<member>` and `<mount>/metadata/<team>/<member>/*` with read/list

Example:

```hcl
module "kv_namespace1" {
	source = "../modules/kv_v2"

	providers = {
		vault = vault.namespace
	}

	mount_path        = "pcs/cloudaccount1/non-prod/kv-v2-test"
	mount_description = "Namespace1 team secrets"

	teams = {
		team1 = {
			members = ["alice", "bob"]
		}
		team2 = {
			members = ["carol", "dave"]
		}
	}
}
```

Use `member_policy_names` output to attach generated policies to auth roles/entities (OIDC/JWT/AppRole) for users and CI/CD identities.

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

cp terraform/hcp-vault/vault-cluster/terraform.tfvars.example terraform/hcp-vault/vault-cluster/non-prod.tfvars
cp terraform/hcp-vault/vault-cluster/terraform.tfvars.example terraform/hcp-vault/vault-cluster/prod.tfvars
```

Set different HCP project IDs per environment:

- `terraform/hcp-vault/vault-cluster/non-prod.tfvars` -> non-prod HCP project ID
- `terraform/hcp-vault/vault-cluster/prod.tfvars` -> prod HCP project ID

Example:

```hcl
# non-prod.tfvars
project_id = "<hcp-non-prod-project-id>"
topology_scenario = "non-prod"

# prod.tfvars
project_id = "<hcp-prod-project-id>"
topology_scenario = "prod"
# Prod uses cluster_1..cluster_6 for HVN/network mapping; Terraform creates Vault clusters for cluster_1, cluster_3, and cluster_5.
```

## Deployment Order

1. Create the Terraform state S3 bucket (run once per environment).
2. Create/select Terraform workspace (`non-prod` or `prod`) in both stacks.
3. Deploy AWS network + Transit Gateways + RAM shares using workspace tfvars.
4. Set HCP provider AWS account IDs in workspace tfvars and re-apply AWS.
5. If `enable_hvn_peering = true`, populate `aws_region_connectivity` in `terraform/hcp-vault/vault-cluster/<workspace>.tfvars` from AWS outputs (TGW IDs, TGW share ARNs, VPC CIDRs).
6. Deploy HCP Vault stack using the matching workspace tfvars (with matching HCP project ID).
7. Accept pending Transit Gateway attachments in AWS (if not auto-accepted).
8. Enable `enable_hcp_tgw_acceptance = true` in AWS workspace tfvars and apply AWS.
9. Re-run plans for both stacks and confirm no changes.

### Azure Deployment Order (HCP Vault + HVN Peering)

1. Create/select a dedicated Azure workspace in `terraform/hcp-vault/vault-cluster` (for example `prod-azure`).
2. Use an Azure-specific tfvars file such as `terraform/hcp-vault/vault-cluster/prod-azure.tfvars` with:
	- `cloud_provider = "azure"`
	- `project_id` for the Azure HCP project
	- `cluster_configs` for cluster_1..cluster_6 HVNs (Terraform-managed Vault clusters are cluster_1, cluster_3, and cluster_5 in prod)
3. Set `enable_hvn_peering = true` in the Azure tfvars file when you want HCP Azure peering and HVN routes created.
4. Populate `azure_region_connectivity` for each active cluster key with VNet identity values and the destination CIDR routed via your Azure NVA path.
5. Run plan/apply in the dedicated Azure workspace using the Azure tfvars file.
6. Confirm peering status is active and re-run plan for convergence.

Azure scope note:

- this Terraform creates HCP-side peering and HVN routes. It does not build Azure-side NVA route tables/UDRs/NVA config; those must already exist or be managed separately.

Workspace tfvars expectations:

- `terraform/aws/non-prod.tfvars`: set `topology_scenario = "non-prod"` and keep regions 1 and 2 only.
- `terraform/aws/prod.tfvars`: set `topology_scenario = "prod"` and set `enable_region_3..enable_region_6 = true`.
- `terraform/hcp-vault/vault-cluster/non-prod.tfvars`: use `cluster_1` and `cluster_2` with AP regions.
- `terraform/hcp-vault/vault-cluster/prod.tfvars`: use `cluster_1..cluster_6` with region mapping shown above.

## Commands

```bash
# 1) Load environment variables
source .env

# 2) One-time setup: create Terraform state bucket (run once)
./scripts/create_s3_bucket.sh <globally-unique-bucket-name> <region>

# 3) Create workspace tfvars
cp terraform/aws/terraform.tfvars.example terraform/aws/non-prod.tfvars
cp terraform/aws/terraform.tfvars.example terraform/aws/prod.tfvars
cp terraform/hcp-vault/vault-cluster/terraform.tfvars.example terraform/hcp-vault/vault-cluster/non-prod.tfvars
cp terraform/hcp-vault/vault-cluster/terraform.tfvars.example terraform/hcp-vault/vault-cluster/prod.tfvars

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
# hcp_provider_account_id_region_4 = "<hcp-provider-account-id>"
# hcp_provider_account_id_region_5 = "<hcp-provider-account-id>"
# hcp_provider_account_id_region_6 = "<hcp-provider-account-id>"

# 8) Re-apply AWS to create RAM principal associations
terraform -chdir=terraform/aws apply -var-file="$TF_ENV.tfvars"

# 9) If enable_hvn_peering=true, capture AWS outputs and populate aws_region_connectivity in
#    terraform/hcp-vault/vault-cluster/$TF_ENV.tfvars for each active cluster key.
#    Example key structure:
#    aws_region_connectivity = {
#      cluster_1 = {
#        transit_gateway_id = "<tgw-id>"
#        resource_share_arn = "<tgw-share-arn>"
#        destination_cidr   = "<aws-vpc-cidr>"
#      }
#    }
terraform -chdir=terraform/aws output tgw_region_1_id
terraform -chdir=terraform/aws output tgw_region_2_id
terraform -chdir=terraform/aws output tgw_region_3_id
terraform -chdir=terraform/aws output tgw_region_4_id
terraform -chdir=terraform/aws output tgw_region_5_id
terraform -chdir=terraform/aws output tgw_region_6_id
terraform -chdir=terraform/aws output tgw_region_1_share_arn
terraform -chdir=terraform/aws output tgw_region_2_share_arn
terraform -chdir=terraform/aws output tgw_region_3_share_arn
terraform -chdir=terraform/aws output tgw_region_4_share_arn
terraform -chdir=terraform/aws output tgw_region_5_share_arn
terraform -chdir=terraform/aws output tgw_region_6_share_arn
terraform -chdir=terraform/aws output vpc_region_1_cidr_block
terraform -chdir=terraform/aws output vpc_region_2_cidr_block
terraform -chdir=terraform/aws output vpc_region_3_cidr_block
terraform -chdir=terraform/aws output vpc_region_4_cidr_block
terraform -chdir=terraform/aws output vpc_region_5_cidr_block
terraform -chdir=terraform/aws output vpc_region_6_cidr_block

# 10) HCP stack: init + same workspace
terraform -chdir=terraform/hcp-vault/vault-cluster init -reconfigure
terraform -chdir=terraform/hcp-vault/vault-cluster workspace new "$TF_ENV" || terraform -chdir=terraform/hcp-vault/vault-cluster workspace select "$TF_ENV"
terraform -chdir=terraform/hcp-vault/vault-cluster workspace show

# 11) HCP Vault on AWS using matching workspace tfvars
terraform -chdir=terraform/hcp-vault/vault-cluster plan  -var-file="$TF_ENV.tfvars"
terraform -chdir=terraform/hcp-vault/vault-cluster apply -var-file="$TF_ENV.tfvars"

# 12) Accept pending Transit Gateway attachments in AWS Console if needed
# VPC/EC2 -> Transit Gateways -> Transit Gateway Attachments -> Accept

# 13) Enable acceptance in terraform/aws/$TF_ENV.tfvars and apply:
# enable_hcp_tgw_acceptance = true
terraform -chdir=terraform/aws apply -var-file="$TF_ENV.tfvars"

# 14) Final convergence check (same workspace)
terraform -chdir=terraform/aws plan -var-file="$TF_ENV.tfvars"
terraform -chdir=terraform/hcp-vault/vault-cluster plan -var-file="$TF_ENV.tfvars"
```

Azure-specific commands (dedicated workspace):

```bash
# 1) Load environment variables (HCP credentials for Azure project)
source .env

# 2) Choose Azure workspace and var file
export TF_AZURE_ENV=prod-azure
export TF_AZURE_VARS=prod-azure.tfvars

# 3) HCP stack: init + dedicated Azure workspace
terraform -chdir=terraform/hcp-vault/vault-cluster init -reconfigure
terraform -chdir=terraform/hcp-vault/vault-cluster workspace new "$TF_AZURE_ENV" || terraform -chdir=terraform/hcp-vault/vault-cluster workspace select "$TF_AZURE_ENV"
terraform -chdir=terraform/hcp-vault/vault-cluster workspace show

# 4) Plan/apply using Azure var file
terraform -chdir=terraform/hcp-vault/vault-cluster plan  -var-file="$TF_AZURE_VARS"
terraform -chdir=terraform/hcp-vault/vault-cluster apply -var-file="$TF_AZURE_VARS"

# 5) Convergence check
terraform -chdir=terraform/hcp-vault/vault-cluster plan -var-file="$TF_AZURE_VARS"
```

Important workspace notes:

- Do not use the `default` workspace for environment deployments.
- Use the same workspace name in both stacks (`non-prod` with `non-prod`, `prod` with `prod`).
- For Azure deployments, use a separate HCP workspace (for example `prod-azure`) in `terraform/hcp-vault/vault-cluster`.
- Recommended Azure workspace names: `non-prod-azure` for non-production and `prod-azure` for production.
- Backends are configured with workspace-isolated S3 paths via `workspace_key_prefix`.

## Transit Gateway Notes

- Transit Gateway is regional; create one TGW per AWS region you plan to map in `aws_region_connectivity`.
- In `prod`, configure connectivity entries for all active cluster keys (`cluster_1`..`cluster_6`) when peering is enabled.
- In `non-prod`, configure connectivity entries for `cluster_1` and `cluster_2` when peering is enabled.
- If HCP apply returns `resource share doesn't exist in the cloud provider`, ensure
	`hcp_provider_account_id_region_1..6` are set in `terraform/aws/<workspace>.tfvars`
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

- `terraform/aws/non-prod.tfvars` and `terraform/hcp-vault/vault-cluster/non-prod.tfvars`
- `terraform/aws/prod.tfvars` and `terraform/hcp-vault/vault-cluster/prod.tfvars`

How to run:

1. Open **GitHub -> Actions**.
2. Select either **Deploy AWS** or **Deploy HCP Vault Cluster**.
3. Click **Run workflow**.
4. Choose `workspace` (`non-prod` or `prod`).
5. Set `apply` to `false` to run plan only.
6. Set `apply` to `true` to run plan and apply.

## Manual DR Cluster Setup (HCP Console)

DR clusters are created only after the HVN and connectivity has been completed.

Edit the existing Vault cluster and create a backup network selecting the DR HVN. 

Guidance:
https://developer.hashicorp.com/vault/tutorials/get-started-hcp-vault-dedicated/manage-clusters#create-cluster-with-cross-region-dr

## Required Environment Variables

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION`
- `HCP_CLIENT_ID`
- `HCP_CLIENT_SECRET`

Optional for HCP Vault provider operations outside this scaffold:

- `VAULT_ADDR`
- `VAULT_TOKEN`