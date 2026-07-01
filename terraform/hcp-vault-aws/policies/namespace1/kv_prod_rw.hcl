# RW access for namespace1 prod KV v2 engine.
path "pcs/cloudaccount1/prod/kv-v2/data/*" {
  capabilities = ["create", "read", "update", "patch"]
}

path "pcs/cloudaccount1/prod/kv-v2/metadata" {
  capabilities = ["read", "list"]
}

path "pcs/cloudaccount1/prod/kv-v2/metadata/*" {
  capabilities = ["read", "list"]
}
