FROM nginx:alpine

# Nginx 설정 파일을 복사
COPY k8s/nginx.conf /etc/nginx/nginx.conf

# 포트 80 노출
EXPOSE 80

# Nginx 실행
CMD ["nginx", "-g", "daemon off;"]