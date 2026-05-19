# DEPLOYMENT

## Local (Docker Compose)
```bash
./scripts/deploy-local.sh
curl http://localhost:9200/_cluster/health
```

## Kubernetes com Helm
```bash
helm upgrade --install elasticsearch ./helm/elasticsearch \
  --namespace elasticsearch \
  --create-namespace \
  --set image.repository=<seu-acr>.azurecr.io/elasticsearch \
  --set image.tag=latest
```

## Via Azure DevOps Pipeline
1. Configure service connections no projeto:
   - ACR (`dockerRegistryServiceConnection`)
   - AKS (`kubernetesServiceConnection`)
2. Ajuste variáveis no `azure-pipelines.yml`.
3. Execute pipeline.
