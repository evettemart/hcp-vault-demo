# User signing access for namespace1 SSH signer mounts in non-prod.
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
