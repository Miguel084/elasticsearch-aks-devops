#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [[ -f "${ROOT_DIR}/.env" ]]; then
  # shellcheck disable=SC1091
  source "${ROOT_DIR}/.env"
fi

: "${AZ_RESOURCE_GROUP:?Defina AZ_RESOURCE_GROUP no .env}"
: "${AZ_LOCATION:?Defina AZ_LOCATION no .env}"
: "${AKS_CLUSTER_NAME:?Defina AKS_CLUSTER_NAME no .env}"
: "${ACR_NAME:?Defina ACR_NAME no .env}"

az group create --name "${AZ_RESOURCE_GROUP}" --location "${AZ_LOCATION}"
az acr create --resource-group "${AZ_RESOURCE_GROUP}" --name "${ACR_NAME}" --sku Basic
az aks create \
  --resource-group "${AZ_RESOURCE_GROUP}" \
  --name "${AKS_CLUSTER_NAME}" \
  --node-count 1 \
  --node-vm-size Standard_D4s_v3 \
  --enable-managed-identity \
  --generate-ssh-keys \
  --attach-acr "${ACR_NAME}"
az aks get-credentials --resource-group "${AZ_RESOURCE_GROUP}" --name "${AKS_CLUSTER_NAME}" --overwrite-existing

echo "AKS configurado com sucesso."
