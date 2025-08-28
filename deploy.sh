#!/usr/bin/env bash
set-euo pipefail

ROOT_DIR=$(cd "$(dirname "$0")" && pwd)
TF_DIR="$ROOT_DIR/terraform"
ROUTER="$ROOT_DIR/local-routing/health-router.sh"

pushd "$TF_DIR" >/dev/null
terraform init-upgrade
terraform apply-auto-approve "$@"
AWS_IP=$(terraform output-raw aws_public_ip)
GCP_IP=$(terraform output-raw gcp_public_ip)
popd >/dev/null

echo "AWS IP: $AWS_IP"
echo "GCP IP: $GCP_IP"

echo "Health endpoints:"
echo "  http://$AWS_IP/health"
echo "  http://$GCP_IP/health"

if command -v dnsmasq >/dev/null; then
    echo "Starting local health router (requires sudo)..."
    sudo bash "$ROUTER" "$AWS_IP" "$GCP_IP" service.multicloud 15 &
    disown
    echo "Visit:  http://service.multicloud/"
else
    echo "dnsmasq not detected. Install it to enable local auto-routing."
fi