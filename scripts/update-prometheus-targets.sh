#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_DIR="${SCRIPT_DIR}/../environments/dev"

cd "${ENV_DIR}"

if [ ! -f "terraform.tfstate" ]; then
  echo "Error: Terraform state not found. Run terraform apply first." >&2
  exit 1
fi

OBSERVABILITY_PUBLIC_IP=$(terraform output -raw observability_ssh_command 2>/dev/null | awk '{print $NF}' || echo "")
VM_PRIVATE_IPS=$(terraform output -json vm_private_ips 2>/dev/null || echo "[]")

if [ -z "$OBSERVABILITY_PUBLIC_IP" ]; then
  echo "Error: Observability stack not found or not deployed." >&2
  exit 1
fi

echo "Updating Prometheus targets on observability stack..."
echo "Observability Public IP: $OBSERVABILITY_PUBLIC_IP"
echo "VM Private IPs: $VM_PRIVATE_IPS"

TARGETS_JSON=$(echo "$VM_PRIVATE_IPS" | jq -r 'map(. + ":12345") | map({targets: [.]})')

ssh -i ~/.ssh/terrarium-key -o StrictHostKeyChecking=no ubuntu@$OBSERVABILITY_PUBLIC_IP bash -c "
  echo '$TARGETS_JSON' > /opt/observability/prometheus-targets.json
  docker exec prometheus kill -HUP 1 2>/dev/null || echo 'Prometheus will reload on next config refresh'
"

echo "Prometheus targets updated successfully!"
echo "Targets file: /opt/observability/prometheus-targets.json"
echo "Prometheus will reload configuration automatically (refresh_interval: 30s)"
