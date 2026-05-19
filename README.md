# Elasticsearch no AKS com Azure DevOps

Estrutura completa para build e deployment de Elasticsearch no AKS usando Azure DevOps Pipeline.

## Estrutura
```text
.
├── azure-pipelines.yml
├── Dockerfile
├── docker-compose.yml
├── .env.example
├── scripts/
│   ├── deploy-local.sh
│   └── setup-aks.sh
├── helm/elasticsearch/
│   ├── Chart.yaml
│   ├── values.yaml
│   └── templates/
│       ├── _helpers.tpl
│       ├── configmap.yaml
│       ├── deployment.yaml
│       ├── pvc.yaml
│       └── service.yaml
├── SETUP.md
├── DEPLOYMENT.md
└── TROUBLESHOOTING.md
```

## Pré-requisitos
- Azure CLI, kubectl, Helm 3
- Docker + Docker Compose
- Azure DevOps Project com service connections para ACR e AKS

## Setup passo-a-passo
1. Copie variáveis:
   ```bash
   cp .env.example .env
   ```
2. Preencha o `.env`.
3. Provisione AKS/ACR:
   ```bash
   ./scripts/setup-aks.sh
   ```
4. Configure service connections no Azure DevOps.

## Configuração da pipeline
No `azure-pipelines.yml`, ajuste:
- `dockerRegistryServiceConnection`
- `containerRegistry`
- `kubernetesServiceConnection`

A pipeline realiza:
1. Build e push da imagem Docker
2. Deploy/upgrade via Helm no namespace `elasticsearch`

## Comandos de verificação
```bash
kubectl get pods -n elasticsearch
kubectl get svc -n elasticsearch
kubectl get pvc -n elasticsearch
kubectl port-forward svc/elasticsearch-elasticsearch -n elasticsearch 9200:9200
curl http://localhost:9200/_cluster/health
```

## Teste local
```bash
./scripts/deploy-local.sh
curl http://localhost:9200/_cluster/health
```

## Troubleshooting
Veja detalhes em [TROUBLESHOOTING.md](./TROUBLESHOOTING.md).

## Customização
- Ajuste memória/CPU em `helm/elasticsearch/values.yaml` (`resources` e `env.esJavaOpts`).
- Altere tipo de serviço em `service.type` (`ClusterIP`, `LoadBalancer`, etc).
- Ajuste persistência em `persistence.*`.
