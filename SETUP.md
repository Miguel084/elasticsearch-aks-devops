# SETUP

## 1) Pré-requisitos
- Azure CLI (`az`)
- Kubectl
- Helm v3
- Docker + Docker Compose
- Conta Azure com permissões para criar RG/AKS/ACR

## 2) Variáveis
1. Copie o template:
   ```bash
   cp .env.example .env
   ```
2. Preencha os valores no `.env`.
   - Se necessário, ajuste `AKS_NODE_VM_SIZE` (default: `Standard_D4s_v3`).

## 3) Provisionar AKS e ACR
```bash
./scripts/setup-aks.sh
```

## 4) Conectar ferramentas
```bash
az aks get-credentials --resource-group <RG> --name <AKS_CLUSTER_NAME>
kubectl get nodes
```
