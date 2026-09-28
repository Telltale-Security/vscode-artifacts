#!/usr/bin/env bash
# Usage: ES_URL=https://localhost:9200 KIBANA_URL=https://localhost:5601 API_KEY=<key> ./deploy.sh
set -euo pipefail
cd "$(dirname "$0")"

: "${ES_URL:?Set ES_URL}"
: "${KIBANA_URL:?Set KIBANA_URL}"
: "${API_KEY:?Set API_KEY}"

es_put() {
  echo "PUT $1"
  curl -sS -X PUT "$ES_URL$1" \
    -H "Authorization: ApiKey $API_KEY" \
    -H "Content-Type: application/json" \
    --data-binary "@$2"
  echo
}

kibana_post() {
  echo "POST $1"
  curl -sS -X POST "$KIBANA_URL$1" \
    -H "Authorization: ApiKey $API_KEY" \
    -H "Content-Type: application/json" \
    -H "kbn-xsrf: true" \
    --data-binary "@$2"
  echo
}

# Set exthost-pipeline as the "Ingest Pipeline" in your Custom Logs (Filestream) integration
es_put /_ingest/pipeline/exthost-pipeline Pipelines/exthost-pipeline.json
es_put /_ingest/pipeline/logs-osquery_manager.result@custom Pipelines/osquery-normalization.json
es_put /_ingest/pipeline/vscode-removed-row Pipelines/vscode-removed-row.json

es_put /_index_template/vscode-removed-stage Index-Templates/vscode-removed-stage.json
es_put /_index_template/vscode-removed-snapshot Index-Templates/vscode-removed-snapshot.json

# Update policy_ids in pack.json to your own Fleet agent policy first
kibana_post /api/osquery/packs OSQuery/pack.json

kibana_post /api/detection_engine/rules Rules/vscode-removed-extension-activated.json
kibana_post /api/detection_engine/rules Rules/vscode-removed-extension-installed.json

jq -Rs '{id: "vscode-removed-refresh", yaml: .}' Workflows/refresh-Microsoft-removed-VS-Code-extensions.yml \
  | kibana_post /api/workflows/workflow -
