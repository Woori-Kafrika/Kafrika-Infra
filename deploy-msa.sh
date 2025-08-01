#!/bin/bash

echo "🚀 MSA 배포 시작..."

# 1. Chat Service 배포
echo "📱 Chat Service 배포 중..."
kubectl apply -f chat-service/k8s/deployment.yaml

# 2. Auth Service 배포
echo "🔐 Auth Service 배포 중..."
kubectl apply -f auth-service/k8s/deployment.yaml

# 3. API Gateway 배포
echo "🌐 API Gateway 배포 중..."
kubectl apply -f api-gateway/k8s/deployment.yaml

# 4. 배포 상태 확인
echo "📊 배포 상태 확인 중..."
kubectl get pods -l app=chat-service
kubectl get pods -l app=auth-service
kubectl get pods -l app=api-gateway

echo "✅ MSA 배포 완료!"
echo ""
echo "📋 서비스 정보:"
echo "  - Chat Service: chat-service:8081"
echo "  - Auth Service: auth-service:8082"
echo "  - API Gateway: api-gateway:80"
echo ""
echo "🌐 외부 접속:"
echo "  - http://kafrika.local (API Gateway를 통한 접속)"
echo ""
echo "🔍 로그 확인:"
echo "  - kubectl logs -l app=chat-service"
echo "  - kubectl logs -l app=auth-service"
echo "  - kubectl logs -l app=api-gateway" 