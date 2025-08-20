# desafio_03
Desafio 03 - SRE - Grafana e Prometheus

## Pré-Requisitos

Minikube instalado

## 01 - Execução do projeto

Dentro da pasta do desafio, executar o script deploy_monitoring.sh: bash deploy_monitoring.sh

## 02 - Adicionando o kube-prometheus-stack, que já traz Prometheus, Grafana, Alertmanager e os CRDs necessários

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install monitoring prometheus-community/kube-prometheus-stack --namespace desafio --create-namespace

## 03 - Adicionando os alertas ao Grafana

kubectl apply -f k8s-alertas.yaml -n desafio

## 04 - Testando o Prometheus

Para verificar se o Prometheus está no ar, acesse http://localhost:9090

## 05 - Testando o Grafana

Para verificar se o Prometheus está no ar, acesse http://localhost:3000

Para acessar o Grafana, utilize o usuário admin, e a senha gerada pelo script

Em Dashboards -> Import -> 6417. Isso trará um template do monitoramento do Kubernetes.

No Data Source, adicionar a URL: http://prometheus-server.desafio.svc.cluster.local

## 06 - Excluindo o lab

Executar o comando: minikube delete (Isso limpará todo o cluster)
