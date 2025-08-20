#!/bin/bash
set -e

NAMESPACE="desafio"

echo "==> Criando namespace (se não existir)..."
kubectl get ns $NAMESPACE >/dev/null 2>&1 || kubectl create ns $NAMESPACE

echo "==> Adicionando repositório Prometheus..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts || true
helm repo update

echo "==> Instalando Prometheus..."
helm upgrade --install prometheus prometheus-community/prometheus --namespace $NAMESPACE

echo "==> Aguardando Prometheus ficar pronto..."
kubectl rollout status deployment prometheus-server -n $NAMESPACE --timeout=180s

echo "==> Adicionando repositório Grafana..."
helm repo add grafana https://grafana.github.io/helm-charts || true
helm repo update

echo "==> Instalando Grafana..."
helm upgrade --install grafana grafana/grafana --namespace $NAMESPACE

echo "==> Aguardando Grafana ficar pronto..."
kubectl rollout status deployment grafana -n $NAMESPACE --timeout=180s

echo "==> Verificando pods do namespace $NAMESPACE..."
kubectl get pods -n $NAMESPACE

echo "==> Expondo o Prometheus na porta 9090..."
PROM_POD=$(kubectl get pods -n $NAMESPACE -l "app.kubernetes.io/name=prometheus,app.kubernetes.io/instance=prometheus" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward -n $NAMESPACE $PROM_POD 9090:9090 &
PF_PROM=$!

echo "==> Expondo o Grafana na porta 3000..."
GRAFANA_POD=$(kubectl get pods -n $NAMESPACE -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=grafana" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward -n $NAMESPACE $GRAFANA_POD 3000:3000 &
PF_GRAFANA=$!

sleep 5
echo "==> Pegando senha do Grafana..."
kubectl get secret --namespace $NAMESPACE grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

echo ""
echo "=============================================="
echo " Prometheus: http://localhost:9090"
echo " Grafana:    http://localhost:3000"
echo " User:       admin"
echo " Password:   (acima)"
echo "=============================================="
echo ""
echo "Para encerrar os port-forwards, rode:"
echo "   kill $PF_PROM $PF_GRAFANA"
