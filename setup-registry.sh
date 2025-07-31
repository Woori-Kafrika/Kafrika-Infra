#!/bin/bash

echo "🔧 Docker Registry 설정 중..."

# Docker Registry가 insecure registry로 설정되어 있는지 확인
if ! grep -q "localhost:5001" /etc/docker/daemon.json 2>/dev/null; then
    echo "📝 Docker daemon.json에 insecure registry 추가..."
    
    # daemon.json 파일이 없으면 생성
    if [ ! -f /etc/docker/daemon.json ]; then
        echo '{"insecure-registries": ["localhost:5001"]}' | sudo tee /etc/docker/daemon.json
    else
        # 기존 파일에 insecure-registries 추가
        sudo jq '.insecure-registries += ["localhost:5001"]' /etc/docker/daemon.json | sudo tee /etc/docker/daemon.json.tmp
        sudo mv /etc/docker/daemon.json.tmp /etc/docker/daemon.json
    fi
    
    echo "🔄 Docker 서비스 재시작 중..."
    sudo systemctl restart docker
    sleep 5
fi

# Docker Registry 테스트
echo "🧪 Docker Registry 연결 테스트..."
docker pull hello-world
docker tag hello-world localhost:5001/hello-world:latest
docker push localhost:5001/hello-world:latest

if [ $? -eq 0 ]; then
    echo "✅ Docker Registry 설정 완료!"
    echo "🌐 Registry URL: http://localhost:5001"
else
    echo "❌ Docker Registry 설정 실패!"
    exit 1
fi 