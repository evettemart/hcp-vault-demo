# Writer access for non-prod KV engine pcs/cloudaccount1/non-prod/kv-v2.
path "pcs/cloudaccount1/non-prod/kv-v2/data/*" {
  capabilities = ["create", "read", "update", "patch"]
}

path "pcs/cloudaccount1/non-prod/kv-v2/metadata" {
  capabilities = ["read", "list"]
}

path "pcs/cloudaccount1/non-prod/kv-v2/metadata/*" {
  capabilities = ["read", "list"]
}
