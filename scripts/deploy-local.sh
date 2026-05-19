#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MAX_RETRIES="${MAX_RETRIES:-30}"
SLEEP_SECONDS="${SLEEP_SECONDS:-5}"

if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
  COMPOSE_CMD=(docker compose)
elif command -v docker-compose >/dev/null 2>&1; then
  COMPOSE_CMD=(docker-compose)
else
  echo "Erro: docker compose (plugin) ou docker-compose não encontrado."
  exit 1
fi

"${COMPOSE_CMD[@]}" -f "${ROOT_DIR}/docker-compose.yml" up -d --build

echo "Aguardando Elasticsearch ficar saudável..."
for ((i=1; i<=MAX_RETRIES; i++)); do
  if curl -fsS "http://localhost:9200/_cluster/health?wait_for_status=yellow&timeout=5s" >/dev/null 2>&1; then
    echo "Elasticsearch disponível em http://localhost:9200"
    exit 0
  fi
  sleep "${SLEEP_SECONDS}"
done

echo "Timeout aguardando Elasticsearch iniciar. Verifique logs com: docker compose logs elasticsearch"
exit 1
