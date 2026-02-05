#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_DIR="${SCRIPT_DIR}/../environments/dev"

cd "${ENV_DIR}"

echo "Initializing Terraform..."
if ! terraform init; then
  echo "Error: Terraform initialization failed" >&2
  exit 1
fi

echo "Validating Terraform configuration..."
if ! terraform validate; then
  echo "Error: Terraform validation failed" >&2
  exit 1
fi

echo "Applying Terraform configuration..."
if ! terraform apply -auto-approve; then
  echo "Error: Terraform apply failed" >&2
  exit 1
fi

echo ""
echo "Infrastructure deployed successfully!"
echo ""
echo "Instance details:"
terraform output

if terraform output -raw grafana_url >/dev/null 2>&1; then
  echo ""
  echo "To update Prometheus scrape targets, run:"
  echo "  ./scripts/update-prometheus-targets.sh"
fi
