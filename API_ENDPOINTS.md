# Kafrika Backend API Endpoints

## 🚀 서버 정보

- **Base URL**: `http://[노드IP]:8080` (Kafrika Backend)
- **API Gateway**: `http://[노드IP]:30512` (Nginx Gateway)

## 📋 API 엔드포인트

### 1. 사용자 관리 (User Management)

#### 회원가입

```
POST /user/signup
Content-Type: application/json

{
  "username": "string",
  "password": "string",
  "email": "string"
}
```

#### 로그인

```
POST /user/login
Content-Type: application/json

{
  "username": "string",
  "password": "string"
}
```

### 2. 채팅 기능 (Chat Features)

#### 채팅 로그 조회

```
GET /chat/log
```

#### WebSocket 연결

```
WebSocket: ws://[노드IP]:8080/ws
```

#### 채팅 메시지 전송 (WebSocket)

```
Message Type: /chat
Payload:
{
  "message": "string",
  "userId": "long",
  "username": "string"
}
```

#### Kafka 채팅 메시지 전송 (WebSocket)

```
Message Type: /kafka-chat
Payload:
{
  "message": "string",
  "userId": "long",
  "username": "string"
}
```

## 🔧 프론트엔드 연동 가이드

### 1. CORS 설정

백엔드에서 다음 도메인들을 허용하도록 설정되어 있습니다:

- `http://localhost:3000` (로컬 개발)
- `https://kafrika-fe.vercel.app` (프로덕션)
- `https://kafrika-frontend.vercel.app` (대체 도메인)

### 2. API 호출 예시 (JavaScript)

#### REST API 호출

```javascript
// 회원가입
const signup = async (userData) => {
  const response = await fetch("http://[노드IP]:8080/user/signup", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(userData),
  });
  return response.json();
};

// 로그인
const login = async (credentials) => {
  const response = await fetch("http://[노드IP]:8080/user/login", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(credentials),
  });
  return response.json();
};

// 채팅 로그 조회
const getChatLog = async () => {
  const response = await fetch("http://[노드IP]:8080/chat/log");
  return response.json();
};
```

#### WebSocket 연결

```javascript
// WebSocket 연결
const socket = new WebSocket("ws://[노드IP]:8080/ws");

// 연결 성공
socket.onopen = () => {
  console.log("WebSocket 연결됨");
};

// 메시지 수신
socket.onmessage = (event) => {
  const message = JSON.parse(event.data);
  console.log("받은 메시지:", message);
};

// 채팅 메시지 전송
const sendChatMessage = (message, userId, username) => {
  socket.send(
    JSON.stringify({
      destination: "/chat",
      body: {
        message: message,
        userId: userId,
        username: username,
      },
    })
  );
};

// Kafka 채팅 메시지 전송
const sendKafkaChatMessage = (message, userId, username) => {
  socket.send(
    JSON.stringify({
      destination: "/kafka-chat",
      body: {
        message: message,
        userId: userId,
        username: username,
      },
    })
  );
};
```

### 3. 응답 형식

#### 성공 응답

```json
{
  "success": true,
  "data": {
    // 응답 데이터
  },
  "message": "성공"
}
```

#### 에러 응답

```json
{
  "success": false,
  "data": null,
  "message": "에러 메시지"
}
```

## 🌐 서버 접근 방법

### 1. 직접 접근

- **Kafrika Backend**: `http://[노드IP]:8080`
- **Auth Service**: `http://[노드IP]:8082`
- **Chat Service**: `http://[노드IP]:8081`

### 2. API Gateway를 통한 접근

- **API Gateway**: `http://[노드IP]:30512`
- **Auth Service**: `http://[노드IP]:30512/auth/`
- **Chat Service**: `http://[노드IP]:30512/chat/`
- **Kafrika Backend**: `http://[노드IP]:30512/api/`

## 📝 참고사항

1. **노드IP**: 실제 서버 IP 주소로 교체하세요
2. **WebSocket**: 실시간 채팅을 위해 WebSocket 연결이 필요합니다
3. **CORS**: 프론트엔드 도메인이 백엔드 CORS 설정에 포함되어야 합니다
4. **인증**: 로그인 후 받은 userId를 채팅 메시지에 포함해야 합니다

## 🔗 프론트엔드 링크

- **프로덕션**: https://kafrika-fe.vercel.app/
