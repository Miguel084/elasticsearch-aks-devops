#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

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
for _ in {1..30}; do
  if curl -fsS "http://localhost:9200/_cluster/health" >/dev/null 2>&1; then
    echo "Elasticsearch disponível em http://localhost:9200"
    exit 0
  fi
  sleep 5
done

echo "Timeout aguardando Elasticsearch iniciar."
exit 1
