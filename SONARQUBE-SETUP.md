# SonarQube 설정 가이드

## 1. SonarQube 설치 (Docker)

### 1.1 SonarQube 컨테이너 실행

```bash
# SonarQube 데이터베이스 (PostgreSQL)
docker run -d \
  --name sonarqube-db \
  -e POSTGRES_USER=sonar \
  -e POSTGRES_PASSWORD=sonar \
  -e POSTGRES_DB=sonar \
  postgres:13

# SonarQube 서버
docker run -d \
  --name sonarqube \
  --link sonarqube-db \
  -p 9000:9000 \
  -e SONAR_JDBC_URL=jdbc:postgresql://sonarqube-db:5432/sonar \
  -e SONAR_JDBC_USERNAME=sonar \
  -e SONAR_JDBC_PASSWORD=sonar \
  sonarqube:latest
```

### 1.2 Docker Compose 사용 (권장)

```yaml
# docker-compose-sonar.yml
version: "3.8"

services:
  sonarqube-db:
    image: postgres:13
    container_name: sonarqube-db
    environment:
      POSTGRES_USER: sonar
      POSTGRES_PASSWORD: sonar
      POSTGRES_DB: sonar
    volumes:
      - sonarqube-db-data:/var/lib/postgresql/data

  sonarqube:
    image: sonarqube:latest
    container_name: sonarqube
    depends_on:
      - sonarqube-db
    ports:
      - "9000:9000"
    environment:
      SONAR_JDBC_URL: jdbc:postgresql://sonarqube-db:5432/sonar
      SONAR_JDBC_USERNAME: sonar
      SONAR_JDBC_PASSWORD: sonar
    volumes:
      - sonarqube-data:/opt/sonarqube/data
      - sonarqube-extensions:/opt/sonarqube/extensions
      - sonarqube-logs:/opt/sonarqube/logs

volumes:
  sonarqube-db-data:
  sonarqube-data:
  sonarqube-extensions:
  sonarqube-logs:
```

실행:

```bash
docker-compose -f docker-compose-sonar.yml up -d
```

## 2. SonarQube 초기 설정

### 2.1 SonarQube 접속

- 브라우저에서 `http://localhost:9000` 접속
- 초기 계정: `admin` / `admin`
- 비밀번호 변경 요구됨

### 2.2 프로젝트 생성

1. **Create Project** 클릭
2. **Manually** 선택
3. **Project display name**: `Kafrika Backend`
4. **Project key**: `kafrika-backend`
5. **Create** 클릭

### 2.3 토큰 생성

1. **Generate a token** 클릭
2. **Token name**: `jenkins-token`
3. **Token** 복사 (예: `sqp_xxxxxxxxxxxxxxxxxxxx`)
4. **Generate** 클릭

## 3. Jenkins 설정

### 3.1 SonarQube 플러그인 설치

1. Jenkins 대시보드 → **Manage Jenkins** → **Plugins**
2. **Available** 탭에서 다음 플러그인 검색 및 설치:
   - **SonarQube Scanner**
   - **SonarQube Quality Gates**

### 3.2 SonarQube 서버 설정

1. Jenkins 대시보드 → **Manage Jenkins** → **Configure System**
2. **SonarQube servers** 섹션에서 **Add SonarQube**
3. 설정:
   - **Name**: `SonarQube`
   - **Server URL**: `http://localhost:9000`
   - **Server authentication token**: 위에서 생성한 토큰 입력

### 3.3 SonarQube Scanner 설정

1. Jenkins 대시보드 → **Manage Jenkins** → **Global Tool Configuration**
2. **SonarQube Scanner installations** 섹션에서 **Add SonarQube Scanner**
3. 설정:
   - **Name**: `SonarQube Scanner`
   - **Install automatically** 체크

### 3.4 Credentials 설정

1. Jenkins 대시보드 → **Manage Jenkins** → **Credentials**
2. **System** → **Global credentials** → **Add Credentials**
3. 설정:
   - **Kind**: Secret text
   - **Secret**: SonarQube 토큰
   - **ID**: `sonar-token`
   - **Description**: SonarQube Token

## 4. Quality Gate 설정

### 4.1 기본 Quality Gate 확인

1. SonarQube → **Quality Gates**
2. **Sonar way** 선택
3. 기본 조건:
   - **Coverage on new code**: 80%
   - **Duplicated lines on new code**: 3%
   - **Maintainability rating on new code**: A
   - **Reliability rating on new code**: A
   - **Security rating on new code**: A
   - **Security hotspots reviewed on new code**: 100%

### 4.2 커스텀 Quality Gate 생성 (선택사항)

1. **Create** 클릭
2. **Name**: `Kafrika Quality Gate`
3. **Conditions** 추가:
   - **Coverage**: 70%
   - **Bugs**: 0
   - **Vulnerabilities**: 0
   - **Code Smells**: 10

## 5. 테스트

### 5.1 로컬 테스트

```bash
# SonarQube 분석 실행
./gradlew sonarqube \
  -Dsonar.projectKey=kafrika-backend \
  -Dsonar.projectName="Kafrika Backend" \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=YOUR_SONAR_TOKEN
```

### 5.2 Jenkins 파이프라인 테스트

1. Jenkins에서 파이프라인 실행
2. **SonarQube Analysis** 단계 확인
3. **Quality Gate** 단계 확인
4. SonarQube 대시보드에서 결과 확인

## 6. 문제 해결

### 6.1 SonarQube 서버 연결 실패

```bash
# 컨테이너 상태 확인
docker ps | grep sonarqube

# 로그 확인
docker logs sonarqube

# 재시작
docker restart sonarqube
```

### 6.2 메모리 부족 오류

```bash
# Docker 메모리 제한 설정
docker run -d \
  --name sonarqube \
  -p 9000:9000 \
  -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true \
  -m 2g \
  sonarqube:latest
```

### 6.3 Jenkins에서 SonarQube 연결 실패

- Jenkins 로그 확인
- SonarQube 토큰 재생성
- Jenkins SonarQube 플러그인 재설치

## 7. 모니터링

### 7.1 SonarQube 상태 확인

```bash
# 컨테이너 상태
docker ps | grep sonarqube

# 로그 확인
docker logs -f sonarqube
```

### 7.2 백업

```bash
# SonarQube 데이터 백업
docker run --rm -v sonarqube-data:/data -v $(pwd):/backup ubuntu tar czf /backup/sonarqube-backup.tar.gz -C /data .
```
