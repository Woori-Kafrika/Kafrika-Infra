# Kafrika-Infra

```shell
# docker 명령어로 Jenkins 실행
docker run -d \
  --name jenkins \
  -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/jenkins:lts
```

```
✅ 1. Jenkins에서 GitHub Credentials 등록
Jenkins 대시보드 → Manage Jenkins → Credentials 클릭

(global) 스코프 아래에서 Add Credentials 클릭

다음과 같이 설정:

Kind: Username with password

Username: GitHub 사용자명

Password: GitHub Personal Access Token (PAT)
→ 생성 방법은 아래 참고

ID: github-token (예: Jenkinsfile에서 쓰기 쉽게)

Description: GitHub Token for Jenkins

```
