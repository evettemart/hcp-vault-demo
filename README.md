# HCP Vault Demo (AWS + Azure)

A demo repository that stands up HCP Vault Dedicated with AWS and Azure connectivity using
Terraform. Review the configuration and select options to match your requirements before applying.

The stacks are:

| Stack | Purpose |
|---|---|
| `terraform/aws` | AWS VPCs, Transit Gateways, RAM shares, routes, and optional RDS test databases |
| `terraform/hcp-vault/vault-cluster` | HCP HVNs, Vault clusters, and HVN peering/routes |
| `terraform/hcp-vault/vault-bootstrap` | Admin-namespace bootstrap: policies, auth methods, namespaces, identity groups |
| `terraform/hcp-vault/namespace1` | Example app-team namespace: policies and secret engines |

## Topology

| | |
|---|---|
| Vault cluster (Prod AWS) | ![Cluster](docs/hcp-vault-AWS.jpg) |
| Transit gateway | ![TGW](docs/hcp-vault-aws-transit-gateway.jpeg) |
| Non-prod | ![Non-prod](docs/hcp-vault-AWS-non-prod.png) |

Environment behavior:

- **non-prod**: deploys regions 1 and 2 only. `cluster_1` is the Terraform-managed Vault cluster; the DR secondary (`cluster_2`) is created manually in HCP.
- **prod**: deploys regions 1–6. Terraform creates Vault clusters for `cluster_1` (primary), `cluster_3`, and `cluster_5` (secondaries); `cluster_2/4/6` are HVN-only DR (created manually).

## Region Mapping

### AWS

| Cluster | AWS Region | HVN Region | Role |
|---|---|---|---|
| cluster_1 | ap-southeast-1 (Singapore) | ap-southeast-1 | Primary |
| cluster_2 | ap-northeast-1 (Tokyo) | ap-northeast-1 | DR HVN only |
| cluster_3 | eu-west-1 (Ireland) | eu-west-1 | Secondary |
| cluster_4 | eu-west-2 (London) | eu-west-2 | DR HVN only |
| cluster_5 | us-east-1 (N. Virginia) | us-east-1 | Secondary |
| cluster_6 | us-east-2 (Ohio) | us-east-2 | DR HVN only |

### Azure

| Cluster | Azure Region | HVN Region | Role |
|---|---|---|---|
| cluster_1 | southeastasia | southeastasia | Primary |
| cluster_2 | japaneast | japaneast | DR HVN only |
| cluster_3 | northeurope | northeurope | Secondary |
| cluster_4 | francecentral | francecentral | DR HVN only |
| cluster_5 | eastus | eastus | Secondary |
| cluster_6 | centralus | centralus | DR HVN only |

## Stacks

### `terraform/aws`

Creates AWS networking (VPCs, subnets, route tables, IGW), one Transit Gateway per region,
VPC attachments, RAM shares, routes to HVN CIDRs, and optional acceptance of HCP TGW attachments.

Optionally creates low-cost Amazon RDS test databases in Region 1 (`enable_test_databases = true`)
for validating the Vault database secret engine — PostgreSQL (port 5432) and MySQL (port 3306).

### `terraform/hcp-vault/vault-cluster`

Deploys HVNs and Vault clusters based on `topology_scenario` (`prod` or `non-prod`).

- Optional HVN peering via `enable_hvn_peering` (default `true`). When enabled, HCP TGW
  attachments and HVN routes back to matching AWS VPCs are created.
- For `cloud_provider = "azure"`, HCP Azure peering connections and HVN routes are created instead.
- `cluster_configs` is required. `aws_region_connectivity` / `azure_region_connectivity` are
  required only when peering is enabled.

Azure scope note: this Terraform creates HCP-side peering and HVN routes only. Azure-side
route tables/UDRs/NVA config must be managed separately.

### `terraform/hcp-vault/vault-bootstrap`

Bootstraps the admin namespace: baseline policies (`policies/admin`), auth methods, child
namespaces, and identity groups.

Supported auth methods:

- `oidc` / `jwt` via `auth_methods`
- OIDC backends via `oidc_auth_methods`
- AWS backends via `aws_auth_methods`
- Azure backends via `azure_auth_methods`
- GCP backends via `gcp_auth_methods`
- AppRole backends via `approle_auth_methods`

#### Identity groups

Identity groups are managed via `namespace_groups`, keyed by namespace (`admin`, or child names
like `namespace1` — not `admin/namespace1`).

- `group_type = "internal"`: Vault-managed membership; no IdP connectivity required.
- `group_type = "external"`: aliases a Vault group to an IdP group (`alias_name`) on a chosen
  OIDC backend.

You do **not** need to paste an OIDC accessor ID. Reference the OIDC mount by name with
`oidc_mount` (the key used in `oidc_auth_methods`) and Terraform resolves the accessor from the
deployed OIDC module output. Accessor resolution order per group:

1. group `oidc_mount` → `module.oidc_admin[<mount>].accessor`
2. namespace `oidc_mount` → `module.oidc_admin[<mount>].accessor`
3. namespace `oidc_accessor` literal (back-compat)
4. inferred admin default when exactly one OIDC method exists (or a method keyed `oidc`)

This lets you deploy one or more OIDC backends and bind different groups to each. See
`terraform/hcp-vault/vault-bootstrap/terraform.tfvars.example`.

### `terraform/hcp-vault/namespace1`

Example app-team namespace managing policies and secret engines. Reusable modules: KV v2
(`modules/kv_v2`) and SSH (`modules/ssh`). Engine maps in `namespace1/non-prod.tfvars`:
`aws_secret_engines`, `database_secret_engines`, `ldap_secret_engines`, `kubernetes_secret_engines`.

Keep engine maps that depend on backing services (AWS, database, LDAP) commented until those
services are available.

## Naming Conventions (Secret Engines and Policies)

Use one path convention for both secret engine mount paths and policy names:

```
<namespace-team>/<cloud-account>/<environment>/<name>
```

Examples:

- Mount path: `pcs/cloudaccount1/non-prod/kv-v2-test`
- Writer policy: `pcs/cloudaccount1/non-prod/kv-v2-test-writer`
- Consumer policy: `pcs/cloudaccount1/non-prod/kv-v2-test-consumer`

Namespace policy files live under `terraform/hcp-vault/policies/<namespace>/`. The nested file
path (minus `.hcl`) becomes the policy name, e.g.
`policies/namespace1/pcs/cloudaccount1/non-prod/kv-v2-test-writer.hcl` →
`pcs/cloudaccount1/non-prod/kv-v2-test-writer`.

To add a namespace: create `terraform/hcp-vault/<namespace>/` (copy the namespace stack pattern)
and `terraform/hcp-vault/policies/<namespace>/`, then add engines and policies using the path
convention above.

## Prerequisites

1. Copy `.env.example` to `.env` and populate AWS values.
2. Log in to HCP, create a project, and copy the project ID into `.env`.
3. Create a service account with admin access; add `HCP_CLIENT_ID` and `HCP_CLIENT_SECRET` to `.env`.
4. `source .env` before running Terraform.

Required environment variables:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION`
- `HCP_CLIENT_ID`
- `HCP_CLIENT_SECRET`

Optional:

- `VAULT_ADDR`
- `VAULT_TOKEN`

Create per-environment tfvars from the examples and set the matching HCP project ID and
`topology_scenario` in each:

```bash
cp terraform/aws/terraform.tfvars.example terraform/aws/non-prod.tfvars
cp terraform/hcp-vault/vault-cluster/terraform.tfvars.example terraform/hcp-vault/vault-cluster/non-prod.tfvars
```

## Deployment (AWS)

Use a dedicated Terraform workspace per environment (never `default`) and the same workspace name
in both stacks.

```bash
source .env
export TF_ENV=non-prod                       # or prod

# One-time: create the Terraform state bucket
./scripts/create_s3_bucket.sh <unique-bucket-name> <region>

# AWS stack
terraform -chdir=terraform/aws init -reconfigure
terraform -chdir=terraform/aws workspace new "$TF_ENV" || terraform -chdir=terraform/aws workspace select "$TF_ENV"
terraform -chdir=terraform/aws apply -var-file="$TF_ENV.tfvars"

# Set hcp_provider_account_id_region_1..6 in terraform/aws/$TF_ENV.tfvars, then re-apply
terraform -chdir=terraform/aws apply -var-file="$TF_ENV.tfvars"

# If enable_hvn_peering=true, populate aws_region_connectivity in the vault-cluster tfvars
# from AWS outputs (TGW IDs, TGW share ARNs, VPC CIDRs), e.g.:
terraform -chdir=terraform/aws output tgw_region_1_id
terraform -chdir=terraform/aws output tgw_region_1_share_arn
terraform -chdir=terraform/aws output vpc_region_1_cidr_block

# HCP Vault cluster stack (same workspace)
terraform -chdir=terraform/hcp-vault/vault-cluster init -reconfigure
terraform -chdir=terraform/hcp-vault/vault-cluster workspace new "$TF_ENV" || terraform -chdir=terraform/hcp-vault/vault-cluster workspace select "$TF_ENV"
terraform -chdir=terraform/hcp-vault/vault-cluster apply -var-file="$TF_ENV.tfvars"

# Accept pending TGW attachments (AWS Console), then enable acceptance and re-apply AWS:
# enable_hcp_tgw_acceptance = true
terraform -chdir=terraform/aws apply -var-file="$TF_ENV.tfvars"

# Convergence check (expect no changes)
terraform -chdir=terraform/aws plan -var-file="$TF_ENV.tfvars"
terraform -chdir=terraform/hcp-vault/vault-cluster plan -var-file="$TF_ENV.tfvars"
```

If HCP apply returns `resource share doesn't exist in the cloud provider`, ensure the
`hcp_provider_account_id_region_*` values are set and the AWS stack has been re-applied to create
RAM principal associations.

## Deployment (Azure)

Use a dedicated Azure workspace (for example `prod-azure`) and an Azure tfvars file with
`cloud_provider = "azure"`, the Azure HCP `project_id`, `cluster_configs`, and (when peering)
`azure_region_connectivity`.

```bash
source .env
export TF_AZURE_ENV=prod-azure
terraform -chdir=terraform/hcp-vault/vault-cluster init -reconfigure
terraform -chdir=terraform/hcp-vault/vault-cluster workspace new "$TF_AZURE_ENV" || terraform -chdir=terraform/hcp-vault/vault-cluster workspace select "$TF_AZURE_ENV"
terraform -chdir=terraform/hcp-vault/vault-cluster apply -var-file="$TF_AZURE_ENV.tfvars"
terraform -chdir=terraform/hcp-vault/vault-cluster plan  -var-file="$TF_AZURE_ENV.tfvars"
```

## KV v2 Module

`terraform/hcp-vault/modules/kv_v2` mounts a KV v2 engine, configures options (max versions, CAS,
delete window), and can generate per-user policies from team/member mappings:

```hcl
module "kv_namespace1" {
  source    = "../modules/kv_v2"
  providers = { vault = vault.namespace }

  mount_path        = "pcs/cloudaccount1/non-prod/kv-v2-test"
  mount_description = "Namespace1 team secrets"

  teams = {
    team1 = { members = ["alice", "bob"] }
    team2 = { members = ["carol", "dave"] }
  }
}
```

Generated policies grant `<mount>/data/<team>/<member>/*` (create/update/patch/read/delete) and
`<mount>/metadata/<team>/<member>` (read/list). Use the `member_policy_names` output to attach
them to auth roles/entities.

## GitHub Actions (On-Demand)

Two manual (`workflow_dispatch`) workflows: `.github/workflows/deploy-aws.yml` and
`.github/workflows/deploy-hcp-vault-cluster.yml`. Both take a `workspace` input (`non-prod` or
`prod`) and an `apply` flag (`false` = plan only), and run with `-var-file=<workspace>.tfvars`.

Required repository secrets: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`,
`HCP_CLIENT_ID`, `HCP_CLIENT_SECRET`.

## Manual DR Cluster Setup

DR clusters are created in the HCP Console after the HVN and connectivity exist: edit the Vault
cluster and add a backup network selecting the DR HVN. See the
[HashiCorp DR guide](https://developer.hashicorp.com/vault/tutorials/get-started-hcp-vault-dedicated/manage-clusters#create-cluster-with-cross-region-dr).
