# ============================================================================
#
# COMANDO PARA FAZER O BUILD DA APLICAÇÃO:
# .\mvnw clean install
#
# COMANDOS PARA CRIAR A IMAGEM:
# docker image build -t test-action-aws:latest .
#
# COMANDOS PARA RODAR O CONTAINER DOCKER:
# docker run --name test-action-aws -p 80:80 test-action-aws:latest
#
# ============================================================================

##### Stage 1: Extract the application
FROM adoptopenjdk:11-jre-hotspot as builder
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} application.jar
RUN java -Djarmode=layertools -jar application.jar extract


###### Stage 2: A minimal docker image
FROM adoptopenjdk:11-jre-hotspot
COPY --from=builder dependencies/ ./
COPY --from=builder snapshot-dependencies/ ./
RUN true
COPY --from=builder spring-boot-loader/ ./
COPY --from=builder application/ ./
ENTRYPOINT ["java", "org.springframework.boot.loader.JarLauncher"]

##FROM openjdk:11-jdk-slim as build
#FROM adoptopenjdk/openjdk11:alpine
#WORKDIR /app
#COPY target/test-action-aws-0.0.1-SNAPSHOT.jar /spring-app.jar
#ENTRYPOINT ["java","-jar","/spring-app.jar"]