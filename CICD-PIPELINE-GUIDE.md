# Jenkins - SonarQube - Docker Registry - ArgoCD - Kubernetes CI/CD 파이프라인

## 🏗️ 전체 아키텍처

```
GitHub → Jenkins → SonarQube → Docker Registry → ArgoCD → Kubernetes
```

## 🚀 1단계: 인프라 실행

### Docker Compose로 모든 서비스 실행

```bash
# 모든 서비스 실행 (Jenkins + SonarQube + Docker Registry)
docker-compose -f docker-compose-local.yml up -d

# 상태 확인
docker ps
```

### Docker Registry 설정

```bash
# Docker Registry 설정 스크립트 실행
chmod +x setup-registry.sh
./setup-registry.sh
```

## 🔧 2단계: Jenkins 설정

### 2-1. Jenkins 초기 설정

1. `http://localhost:8080` 접속
2. 초기 비밀번호: `784f812a365147d9af81a44897cb11be`
3. 추천 플러그인 설치
4. 관리자 계정 생성

### 2-2. 필요한 플러그인 설치

- **SonarQube Scanner**
- **SonarQube Quality Gates**
- **Docker Pipeline**
- **GitHub Integration**
- **Kubernetes CLI**

### 2-3. Credentials 설정

1. **Manage Jenkins** → **Credentials**
2. 다음 Credentials 추가:

#### SonarQube Token

- **Kind**: Secret text
- **Secret**: SonarQube 토큰
- **ID**: `sonar-token`

#### GitHub Token

- **Kind**: Username with password
- **Username**: GitHub 사용자명
- **Password**: GitHub Personal Access Token
- **ID**: `github-token`

#### ArgoCD Token (선택사항)

- **Kind**: Secret text
- **Secret**: ArgoCD 토큰
- **ID**: `argocd-token`

## 🔍 3단계: SonarQube 설정

### 3-1. SonarQube 초기 설정

1. `http://localhost:9000` 접속
2. 초기 계정: `admin` / `admin`
3. 비밀번호 변경

### 3-2. 프로젝트 생성

1. **Create Project** 클릭
2. **Manually** 선택
3. **Project display name**: `Kafrika Backend`
4. **Project key**: `kafrika-backend`
5. 토큰 생성 및 복사

### 3-3. Jenkins와 SonarQube 연결

1. Jenkins → **Manage Jenkins** → **Configure System**
2. **SonarQube servers** → **Add SonarQube**
3. 설정:
   - **Name**: `SonarQube`
   - **Server URL**: `http://localhost:9000`
   - **Server authentication token**: 위에서 생성한 토큰

## 🐳 4단계: Docker Registry 설정

### 4-1. Registry 접속 확인

```bash
# Registry 상태 확인
curl http://localhost:5000/v2/_catalog

# 이미지 목록 확인
curl http://localhost:5000/v2/kafrika-backend/tags/list
```

### 4-2. Docker Registry 테스트

```bash
# 테스트 이미지 빌드 및 푸시
docker build -t localhost:5000/kafrika-backend:test .
docker push localhost:5000/kafrika-backend:test
```

## ⚙️ 5단계: Kubernetes 설정

### 5-1. kubectl 설정 확인

```bash
# Kubernetes 클러스터 연결 확인
kubectl cluster-info

# 네임스페이스 확인
kubectl get namespaces
```

### 5-2. ArgoCD Application 배포

```bash
# ArgoCD Application 생성
kubectl apply -f argocd/application.yaml

# Application 상태 확인
kubectl get applications -n argocd
```

## 🎯 6단계: Jenkins 파이프라인 생성

### 6-1. 새 Pipeline Job 생성

1. Jenkins 대시보드 → **New Item**
2. **Pipeline** 선택
3. **Job name**: `kafrika-backend-cicd`

### 6-2. Pipeline 설정

1. **Pipeline** 섹션에서:
   - **Definition**: `Pipeline script from SCM`
   - **SCM**: `Git`
   - **Repository URL**: `https://github.com/your-username/Kafrika-Infra.git`
   - **Credentials**: `github-token` 선택
   - **Branch Specifier**: `*/main`
   - **Script Path**: `Jenkins/jenkinsfile-backend`

### 6-3. 빌드 트리거 설정

- **GitHub hook trigger for GITScm polling** 체크
- 또는 **Poll SCM**: `H/5 * * * *` (5분마다)

## 🧪 7단계: 파이프라인 테스트

### 7-1. 수동 빌드 테스트

1. 생성한 파이프라인 Job 클릭
2. **Build Now** 클릭
3. 빌드 진행 상황 모니터링

### 7-2. 각 단계 확인

- ✅ **Checkout**: 소스코드 체크아웃
- ✅ **Build**: Gradle 빌드
- ✅ **Test**: 테스트 실행
- ✅ **SonarQube Analysis**: 코드 품질 분석
- ✅ **Quality Gate**: 품질 게이트 통과
- ✅ **Docker Build**: Docker 이미지 빌드
- ✅ **Docker Push**: Registry에 이미지 푸시
- ✅ **Update Kubernetes Manifests**: K8s 매니페스트 업데이트
- ✅ **Deploy to Kubernetes**: Kubernetes 배포

## 📊 8단계: 모니터링

### 8-1. 배포 상태 확인

```bash
# Kubernetes 배포 상태
kubectl get pods -l app=kafrika-backend

# 서비스 상태
kubectl get services

# Ingress 상태
kubectl get ingress
```

### 8-2. ArgoCD 대시보드

- ArgoCD UI에서 Application 상태 확인
- Sync 상태 및 배포 히스토리 확인

### 8-3. 애플리케이션 접속

```bash
# 포트 포워딩으로 접속 테스트
kubectl port-forward svc/kafrika-backend-service 8080:80
```

## 🔍 9단계: 문제 해결

### 9-1. 일반적인 문제들

#### Docker Registry 연결 실패

```bash
# Docker daemon 설정 확인
cat /etc/docker/daemon.json

# Docker 서비스 재시작
sudo systemctl restart docker
```

#### Kubernetes 연결 실패

```bash
# kubectl 설정 확인
kubectl config current-context

# 클러스터 정보 확인
kubectl cluster-info
```

#### ArgoCD Sync 실패

```bash
# Application 로그 확인
kubectl logs -n argocd deployment/argocd-server

# Application 상태 확인
kubectl describe application kafrika-backend -n argocd
```

### 9-2. 로그 확인

```bash
# Jenkins 로그
docker logs jenkins-local

# SonarQube 로그
docker logs sonarqube-local

# Docker Registry 로그
docker logs docker-registry-local
```

## 🚀 10단계: 자동화

### 10-1. GitHub Webhook 설정

1. GitHub 저장소 → Settings → Webhooks
2. **Add webhook** 클릭
3. 설정:
   - **Payload URL**: `http://localhost:8080/github-webhook/`
   - **Content type**: `application/json`
   - **Events**: `Just the push event`

### 10-2. 자동 배포 테스트

1. 코드 변경 후 GitHub에 푸시
2. Jenkins 자동 빌드 시작
3. ArgoCD 자동 동기화
4. Kubernetes 자동 배포

## 📈 11단계: 고급 설정

### 11-1. 롤백 전략

- ArgoCD에서 이전 버전으로 롤백
- Jenkins에서 특정 빌드 재실행

### 11-2. 환경별 배포

- 개발/스테이징/프로덕션 환경 분리
- 환경별 ArgoCD Application 생성

### 11-3. 보안 강화

- Docker Registry 인증 설정
- Kubernetes RBAC 설정
- Jenkins 보안 설정

## 🎉 완료!

이제 완전한 CI/CD 파이프라인이 구축되었습니다:

1. **코드 푸시** → GitHub
2. **자동 빌드** → Jenkins
3. **코드 품질 분석** → SonarQube
4. **Docker 이미지 빌드/푸시** → Docker Registry
5. **자동 배포** → ArgoCD → Kubernetes
