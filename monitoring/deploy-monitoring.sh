#!/bin/bash

echo "🚀 Deploying Monitoring Stack (Prometheus + Loki + Promtail)..."

# 1. Prometheus 배포
echo "📊 Deploying Prometheus..."
kubectl apply -f prometheus-config.yaml
kubectl apply -f prometheus-deployment.yaml

# 2. Loki 배포
echo "📝 Deploying Loki..."
kubectl apply -f loki-config.yaml
kubectl apply -f loki-deployment.yaml

# 3. Promtail 배포
echo "🔍 Deploying Promtail..."
kubectl apply -f promtail-config.yaml
kubectl apply -f promtail-deployment.yaml

# 4. 배포 상태 확인
echo "⏳ Waiting for deployments to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/prometheus
kubectl wait --for=condition=available --timeout=300s deployment/loki
kubectl wait --for=condition=available --timeout=300s daemonset/promtail

# 5. 서비스 정보 출력
echo "✅ Monitoring Stack deployed successfully!"
echo ""
echo "📊 Prometheus:"
echo "  - Service: prometheus-service"
echo "  - Port: 9090"
echo "  - Access: kubectl port-forward service/prometheus-service 9090:9090"
echo ""
echo "📝 Loki:"
echo "  - Service: loki-service"
echo "  - Port: 3100"
echo "  - Access: kubectl port-forward service/loki-service 3100:3100"
echo ""
echo "🔍 Promtail:"
echo "  - DaemonSet: promtail"
echo "  - Log collection: Automatic from all pods"
echo ""
echo "📈 Current status:"
kubectl get pods -l app=prometheus
kubectl get pods -l app=loki
kubectl get pods -l app=promtail 