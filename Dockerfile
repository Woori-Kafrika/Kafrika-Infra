# 멀티 스테이지 빌드 최적화
FROM gradle:8.5-jdk17 AS builder

WORKDIR /app

# Gradle 캐시 최적화를 위해 dependency 파일들 먼저 복사
COPY build.gradle settings.gradle ./
COPY gradle ./gradle
COPY gradlew gradlew.bat ./

# 의존성만 먼저 다운로드 (캐시 활용)
RUN gradle dependencies --no-daemon

# 소스코드 복사 및 빌드
COPY src ./src
RUN gradle clean build --no-daemon -x test --parallel

# 런타임 이미지
FROM --platform=linux/amd64 openjdk:17-jre-slim

RUN groupadd -r appuser && useradd -r -g appuser appuser

WORKDIR /app

# JAR 파일만 복사
COPY --from=builder /app/build/libs/*.jar app.jar

RUN chown -R appuser:appuser /app

USER appuser

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]