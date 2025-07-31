# Multi-stage build for Java Spring Boot application
FROM gradle:8.5-jdk17 AS builder

WORKDIR /app
COPY build.gradle settings.gradle ./
COPY gradle ./gradle
COPY gradlew gradlew.bat ./
COPY src ./src

# Build the application
RUN gradle clean build --no-daemon -x test

# Runtime stage with correct base image
FROM eclipse-temurin:17-jre

# Add metadata
LABEL maintainer="your-team@company.com"
LABEL version="1.0"
LABEL description="Kafrika Backend Application"

# Create non-root user
RUN groupadd -r appuser && useradd -r -g appuser -d /app -s /bin/false appuser

WORKDIR /app

# Copy jar file from builder stage
COPY --from=builder /app/build/libs/*.jar app.jar

# Change ownership to appuser
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/actuator/health || exit 1

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "-Dspring.profiles.active=prod", "app.jar"]