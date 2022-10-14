# ===================== Dockerfile da imagem de PRODUÇÃO =====================
# COMANDOS PARA CRIAR A IMAGEM:
# docker image build -t test-action-aws:latest .

# COMANDOS PARA RODAR O CONTAINER DOCKER:
# docker run --name test-action-aws -p 8080:8080 test-action-aws:latest

#FROM openjdk:11-jdk-slim as build
FROM adoptopenjdk/openjdk11:alpine

WORKDIR /app

COPY target/test-action-aws-0.0.1-SNAPSHOT.jar /spring-app.jar

ENTRYPOINT ["java","-jar","/spring-app.jar"]