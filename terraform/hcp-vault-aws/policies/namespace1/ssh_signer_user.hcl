# Allow user certificate signing only on namespace1 SSH signer mounts.
# No role or CA management capabilities are granted.

path "pcs/cloudaccount1/non-prod/ssh-signer/sign/*" {
  capabilities = ["update"]
}

path "pcs/cloudaccount1/non-prod/ssh-signer/public_key" {
  capabilities = ["read"]
}

path "pcs/cloudaccount1/non-prod/ssh-signer2/sign/*" {
  capabilities = ["update"]
}

path "pcs/cloudaccount1/non-prod/ssh-signer2/public_key" {
  capabilities = ["read"]
}
