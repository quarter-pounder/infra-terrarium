#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_DIR="${SCRIPT_DIR}/../environments/dev"

cd "${ENV_DIR}"

if [ ! -d ".terraform" ]; then
  echo "Terraform not initialized. Running init..."
  if ! terraform init; then
    echo "Error: Terraform initialization failed" >&2
    exit 1
  fi
fi

echo "Destroying infrastructure..."
if ! terraform destroy -auto-approve; then
  echo "Error: Terraform destroy failed" >&2
  exit 1
fi

echo ""
echo "Infrastructure destroyed successfully!"
