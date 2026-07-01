# Writer access for non-prod KV engine pcs/cloudaccount1/non-prod/kv-v2-test.
path "pcs/cloudaccount1/non-prod/kv-v2-test/data/*" {
  capabilities = ["create", "read", "update", "patch"]
}

path "pcs/cloudaccount1/non-prod/kv-v2-test/metadata" {
  capabilities = ["read", "list"]
}

path "pcs/cloudaccount1/non-prod/kv-v2-test/metadata/*" {
  capabilities = ["read", "list"]
}
