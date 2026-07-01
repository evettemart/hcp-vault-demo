# kv_v2 module

Reusable Vault KV v2 module that:

- mounts a KV v2 secrets engine
- configures KV v2 options (versions, CAS, delete window in seconds)
- generates per-user policies scoped to `team/member` paths

## Policy model

For each `team/member`, a policy is generated with access to:

- `<mount>/data/<team>/<member>/*` for create/update/patch/read/delete
- `<mount>/metadata/<team>/<member>` and `.../*` for read/list

This supports least privilege where each user sees only their own keyspace.

## Example

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

Use `member_policy_names` output to attach policies to auth roles/entities (OIDC/JWT/AppRole) for users and CI/CD identities.
