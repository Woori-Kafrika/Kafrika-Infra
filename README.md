# Kafrika MSA Infrastructure

[![Kubernetes](https://img.shields.io/badge/Kubernetes-1.28.15-326CE5?style=plastic&logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![Spring Boot](https://img.shields.io/badge/Spring_Boot-3.5.4-6DB33F?style=plastic&logo=spring-boot&logoColor=white)](https://spring.io/projects/spring-boot)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-336791?style=plastic&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Apache Kafka](https://img.shields.io/badge/Apache_Kafka-3.5-231F20?style=plastic&logo=apache-kafka&logoColor=white)](https://kafka.apache.org/)
[![Docker](https://img.shields.io/badge/Docker-26.1.3-2496ED?style=plastic&logo=docker&logoColor=white)](https://www.docker.com/)
[![ArgoCD](https://img.shields.io/badge/ArgoCD-2.8.0-EF7B4D?style=plastic&logo=argocd&logoColor=white)](https://argoproj.github.io/argo-cd/)
[![Nginx](https://img.shields.io/badge/Nginx-1.24-009639?style=plastic&logo=nginx&logoColor=white)](https://nginx.org/)

## 📋 프로젝트 개요

Kafrika는 **Microservice Architecture (MSA)** 기반의 채팅 애플리케이션입니다. 쿠버네티스 환경에서 각 서비스를 독립적으로 배포하고 관리하며, Kafka를 통한 메시지 큐 처리와 PostgreSQL 데이터베이스를 활용합니다.

## 🏗️ 아키텍처

<img width="719" height="472" alt="image" src="https://github.com/user-attachments/assets/13406e86-c052-4037-8d11-f9e2386c8899" />


## 🚀 배포된 서비스

| 서비스              | 포트  | 레플리카 | 상태       | 설명                 |
| ------------------- | ----- | -------- | ---------- | -------------------- |
| **API Gateway**     | 30512 | 1        | ✅ Running | Nginx 기반 라우팅    |
| **Auth Service**    | 8082  | 2        | ✅ Running | 사용자 인증/인가     |
| **Chat Service**    | 8081  | 2        | ✅ Running | 채팅 메시지 처리     |
| **Kafrika Backend** | 8080  | 2        | ✅ Running | 기존 모놀리식 서비스 |
| **PostgreSQL**      | 5432  | 1        | ✅ Running | 메인 데이터베이스    |
| **Kafka**           | 9092  | 1        | ✅ Running | 메시지 큐            |
| **Zookeeper**       | 2181  | 1        | ✅ Running | Kafka 관리           |

## 🖥️ 인프라 구성

### 쿠버네티스 클러스터

- **test-con1**: 워커 노드
- **test-no1**: 워커 노드
- **test-no2**: 컨트롤 플레인

### 기술 스택

- **컨테이너 오케스트레이션**: Kubernetes v1.28.15
- **CI/CD**: ArgoCD v2.8.0
- **데이터베이스**: PostgreSQL 15 (Docker)
- **메시지 큐**: Apache Kafka 3.5
- **API Gateway**: Nginx
- **애플리케이션**: Spring Boot 3.5.4

## 📁 프로젝트 구조

```
Kafrika-Infra/
├── auth-service/                 # 인증 서비스
│   ├── src/
│   ├── Dockerfile
│   └── k8s/
├── chat-service/                 # 채팅 서비스
│   ├── src/
│   ├── Dockerfile
│   └── k8s/
├── api-gateway/                  # API 게이트웨이
│   └── k8s/
├── k8s/                         # 기존 모놀리식 배포
│   ├── deployment.yaml
│   ├── service.yaml
│   └── configmap.yaml
├── argocd/                      # ArgoCD 설정
│   └── application.yaml
└── README.md
```

## 🔧 설치 및 배포

### 1. 사전 요구사항

- Kubernetes 클러스터
- Docker
- kubectl
- ArgoCD

### 2. 데이터베이스 설정

```bash
# PostgreSQL Docker 컨테이너 실행
docker run -d \
  --name postgres-kafrika \
  --network host \
  -e POSTGRES_DB=kafrika \
  -e POSTGRES_USER=kafrika_user \
  -e POSTGRES_PASSWORD=kafrika_password \
  -v postgres_data:/var/lib/postgresql/data \
  postgres:15
```

### 3. 쿠버네티스 배포

```bash
# 서비스 배포
kubectl apply -f auth-service/k8s/deployment.yaml
kubectl apply -f chat-service/k8s/deployment.yaml
kubectl apply -f api-gateway/k8s/deployment.yaml

# ArgoCD 동기화
argocd app sync kafrika-backend
```

### 4. 서비스 확인

```bash
# 파드 상태 확인
kubectl get pods

# 서비스 확인
kubectl get services

# API Gateway 접근
curl http://[노드IP]:30512/
```

## 🧪 API 엔드포인트

### API Gateway (Port 30512)

- **Auth Service**: `http://[노드IP]:30512/auth/`
- **Chat Service**: `http://[노드IP]:30512/chat/`
- **Kafrika Backend**: `http://[노드IP]:30512/api/`

### 직접 접근

- **Auth Service**: `http://[노드IP]:8082/`
- **Chat Service**: `http://[노드IP]:8081/`
- **Kafrika Backend**: `http://[노드IP]:8080/`

## 📊 모니터링

### 로그 확인

```bash
# Auth Service 로그
kubectl logs -l app=auth-service

# Chat Service 로그
kubectl logs -l app=chat-service

# Kafka 로그
kubectl logs -l app=kafka
```

### 리소스 사용량

```bash
# 노드 리소스 확인
kubectl top nodes

# 파드 리소스 확인
kubectl top pods
```

## 🔄 CI/CD 파이프라인

### ArgoCD 설정

- **GitOps**: GitHub 저장소 기반 배포
- **자동 동기화**: 코드 변경 시 자동 배포
- **롤백**: 이전 버전으로 쉽게 복구

### Docker 이미지

- **Auth Service**: `chathongpt/auth-service:v1`
- **Chat Service**: `chathongpt/chat-service:v1`
- **Kafrika Backend**: `chathongpt/kafrika-backend:v52`

## 🚨 문제 해결

### 일반적인 문제들

1. **파드 CrashLoopBackOff**: 환경변수 또는 설정 확인
2. **서비스 연결 실패**: 네트워크 정책 및 포트 확인
3. **데이터베이스 연결 실패**: PostgreSQL 컨테이너 상태 확인

### 디버깅 명령어

```bash
# 파드 상세 정보
kubectl describe pod <pod-name>

# 로그 확인
kubectl logs <pod-name>

# 서비스 엔드포인트 확인
kubectl get endpoints
```

## 📈 성능 테스트

### JMeter 부하 테스트

- **동시 사용자**: 10-200명
- **테스트 시간**: 5-30분
- **API 엔드포인트**: Auth, Chat, Backend 서비스

### 성능 지표

- **응답 시간**: < 500ms
- **처리량**: > 1000 TPS
- **가용성**: 99.9%

## 🤝 기여하기

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 `LICENSE` 파일을 참조하세요.

## 📞 연락처

- **프로젝트 링크**: [https://github.com/your-username/Kafrika-Infra](https://github.com/your-username/Kafrika-Infra)
- **이슈 리포트**: [https://github.com/your-username/Kafrika-Infra/issues](https://github.com/your-username/Kafrika-Infra/issues)

---

⭐ 이 프로젝트가 도움이 되었다면 스타를 눌러주세요!
