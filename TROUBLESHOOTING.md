# TROUBLESHOOTING

## Pod não sobe
```bash
kubectl describe pod -n elasticsearch <pod>
kubectl logs -n elasticsearch <pod>
```
Verifique recursos (CPU/memória) e PVC.

## Serviço sem IP externo
```bash
kubectl get svc -n elasticsearch
```
Aguarde provisionamento do LoadBalancer ou altere `service.type` para `ClusterIP`.

## Falha no pull da imagem
- Confirme acesso do AKS ao ACR (`--attach-acr` no setup).
- Verifique `image.repository` e tag.

## Healthcheck falhando
- Aguarde warm-up inicial do Elasticsearch.
- Confira endpoint:
  ```bash
  curl http://<host>:9200/_cluster/health
  ```
