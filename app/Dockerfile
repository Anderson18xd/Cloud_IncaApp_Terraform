FROM alpine:latest
RUN apk upgrade --no-cache && echo "Hola desde IncaApp en AWS ECR" > /index.txt
CMD ["cat", "/index.txt"]