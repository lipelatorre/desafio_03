# Desafio_03
Desafio 03 - SRE - Grafana e Prometheus

## Pré-Requisitos

- [Minikube](https://minikube.sigs.k8s.io/docs/start/)  
- [kubectl](https://kubernetes.io/docs/tasks/tools/)  
- [Helm](https://helm.sh/docs/intro/install/)  
- Docker (dependência para rodar o Minikube)  

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

Para verificar se o Grafana está no ar, acesse http://localhost:3000

Para acessar o Grafana, utilize o usuário admin, e a senha gerada pelo script. Ou podemos obter a senha com o comando: kubectl get secret --namespace desafio monitoring-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

Em Dashboards -> Import -> 6417. Isso trará um template do monitoramento do Kubernetes.

No Data Source, adicionar a URL: http://prometheus-server.desafio.svc.cluster.local

## 06 - Excluindo o lab

Executar o comando: minikube delete (Isso limpará todo o cluster)
