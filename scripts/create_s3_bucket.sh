#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<EOF
Usage: $(basename "$0") <bucket-name> [region]

Creates an S3 bucket using AWS CLI.

Arguments:
  bucket-name   Globally unique S3 bucket name
  region        AWS region (optional, defaults to AWS_REGION env var or us-east-1)

Examples:
  $(basename "$0") my-hcp-vault-demo-state-123456
  $(basename "$0") my-hcp-vault-demo-state-123456 ap-southeast-1
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ $# -lt 1 || $# -gt 2 ]]; then
  usage >&2
  exit 1
fi

if ! command -v aws >/dev/null 2>&1; then
  echo "Error: aws CLI not found in PATH." >&2
  exit 1
fi

bucket_name="$1"
region="${2:-${AWS_REGION:-us-east-1}}"

if aws s3api head-bucket --bucket "$bucket_name" >/dev/null 2>&1; then
  echo "Bucket already exists and is accessible: $bucket_name"
  exit 0
fi

if [[ "$region" == "us-east-1" ]]; then
  aws s3api create-bucket --bucket "$bucket_name"
else
  aws s3api create-bucket \
    --bucket "$bucket_name" \
    --region "$region" \
    --create-bucket-configuration LocationConstraint="$region"
fi

echo "Created bucket: $bucket_name (region: $region)"
