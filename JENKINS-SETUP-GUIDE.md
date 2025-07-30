# Jenkins 설정 가이드

## 🚀 Jenkins 접속

- **URL**: http://localhost:8080
- **초기 비밀번호**: `784f812a365147d9af81a44897cb11be`

## 📋 단계별 설정

### 1단계: 초기 설정

1. 브라우저에서 `http://localhost:8080` 접속
2. 위의 초기 비밀번호 입력
3. **"Install suggested plugins"** 클릭 (추천 플러그인 설치)
4. 설치 완료까지 대기 (약 3-4분)

### 2단계: 관리자 계정 생성

1. **Create First Admin User** 화면에서:
   - **Username**: `admin`
   - **Password**: 원하는 비밀번호 입력
   - **Full name**: `Administrator`
   - **Email address**: 이메일 주소 입력
2. **Save and Continue** 클릭

### 3단계: Jenkins URL 설정

1. **Jenkins URL**: `http://localhost:8080` 확인
2. **Save and Finish** 클릭

### 4단계: Jenkins 준비 완료

1. **Start using Jenkins** 클릭
2. Jenkins 대시보드 접속 확인

## 🔧 SonarQube 플러그인 설치

### 4-1. SonarQube 플러그인 설치

1. **Manage Jenkins** → **Plugins** 클릭
2. **Available** 탭에서 다음 플러그인 검색 및 설치:
   - `SonarQube Scanner`
   - `SonarQube Quality Gates`
   - `GitHub Integration`
   - `GitHub API Plugin`
   - `Pipeline`
   - `Docker Pipeline`

### 4-2. SonarQube 서버 설정

1. **Manage Jenkins** → **Configure System** 클릭
2. **SonarQube servers** 섹션에서 **Add SonarQube** 클릭
3. 설정:
   - **Name**: `SonarQube`
   - **Server URL**: `http://localhost:9000`
   - **Server authentication token**: (나중에 설정)

### 4-3. SonarQube Scanner 설정

1. **Manage Jenkins** → **Global Tool Configuration** 클릭
2. **SonarQube Scanner installations** 섹션에서 **Add SonarQube Scanner** 클릭
3. 설정:
   - **Name**: `SonarQube Scanner`
   - **Install automatically** 체크

## 🎯 프로젝트 파이프라인 생성

### 5단계: 새 Pipeline Job 생성

1. Jenkins 대시보드에서 **New Item** 클릭
2. **Pipeline** 선택
3. **Job name**: `kafrika-backend-pipeline`
4. **OK** 클릭

### 5-1. Pipeline 설정

1. **Pipeline** 섹션에서:
   - **Definition**: `Pipeline script from SCM` 선택
   - **SCM**: `Git` 선택
   - **Repository URL**: `https://github.com/your-username/Kafrika-Infra.git`
   - **Credentials**: (GitHub 토큰 설정 필요)
   - **Branch Specifier**: `*/main`
   - **Script Path**: `Jenkins/jenkinsfile-backend`

### 5-2. 빌드 트리거 설정

- **GitHub hook trigger for GITScm polling** 체크
- 또는 **Poll SCM** 설정: `H/5 * * * *` (5분마다)

## 🔑 GitHub Credentials 설정

### 6단계: GitHub Personal Access Token 생성

1. GitHub → Settings → Developer settings → Personal access tokens
2. **Generate new token (classic)** 클릭
3. 권한 설정:
   - `repo` (전체 저장소 접근)
   - `admin:repo_hook` (웹훅 관리)
4. 토큰 생성 후 복사

### 6-1. Jenkins Credentials 등록

1. **Manage Jenkins** → **Credentials** 클릭
2. **System** → **Global credentials** → **Add Credentials** 클릭
3. 설정:
   - **Kind**: `Username with password`
   - **Username**: GitHub 사용자명
   - **Password**: 위에서 생성한 GitHub 토큰
   - **ID**: `github-token`
   - **Description**: `GitHub Token for Jenkins`

## 🧪 테스트

### 7단계: 파이프라인 테스트

1. 생성한 파이프라인 Job 클릭
2. **Build Now** 클릭
3. 빌드 진행 상황 확인
4. **Console Output**에서 로그 확인

## 🔍 문제 해결

### 빌드 실패 시 확인사항:

1. **Java 버전**: `java -version`
2. **Gradle 권한**: `chmod +x gradlew`
3. **GitHub 토큰**: 올바른 권한 설정 확인
4. **SonarQube 연결**: SonarQube 서버 상태 확인

### 로그 확인:

```bash
# Jenkins 로그
docker logs jenkins-local

# SonarQube 로그
docker logs sonarqube-local
```

## 📊 모니터링

### 빌드 상태 확인:

- Jenkins 대시보드에서 빌드 히스토리 확인
- SonarQube 대시보드에서 코드 품질 분석 결과 확인

### 알림 설정:

- GitHub Webhook 설정 (선택사항)
- 이메일 알림 설정 (선택사항)
