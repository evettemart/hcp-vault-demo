# Allow SSH signer role and CA management for namespace1 SSH signer mounts.

path "pcs/cloudaccount1/non-prod/ssh-signer/config/ca" {
  capabilities = ["create", "read", "update", "delete"]
}

path "pcs/cloudaccount1/non-prod/ssh-signer/roles" {
  capabilities = ["list"]
}

path "pcs/cloudaccount1/non-prod/ssh-signer/roles/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "pcs/cloudaccount1/non-prod/ssh-signer/sign/*" {
  capabilities = ["update"]
}

path "pcs/cloudaccount1/non-prod/ssh-signer/public_key" {
  capabilities = ["read"]
}

path "pcs/cloudaccount1/non-prod/ssh-signer2/config/ca" {
  capabilities = ["create", "read", "update", "delete"]
}

path "pcs/cloudaccount1/non-prod/ssh-signer2/roles" {
  capabilities = ["list"]
}

path "pcs/cloudaccount1/non-prod/ssh-signer2/roles/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "pcs/cloudaccount1/non-prod/ssh-signer2/sign/*" {
  capabilities = ["update"]
}

path "pcs/cloudaccount1/non-prod/ssh-signer2/public_key" {
  capabilities = ["read"]
}
