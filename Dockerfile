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

##FROM openjdk:11-jdk-slim as build
#FROM adoptopenjdk/openjdk11:alpine
#WORKDIR /app
#COPY target/test-action-aws-0.0.1-SNAPSHOT.jar /spring-app.jar
#ENTRYPOINT ["java","-jar","/spring-app.jar"]


##### Stage 1: Extract the application
FROM openjdk:11-jre-slim as builder
WORKDIR extracted
ADD ./target/*.jar app.jar
RUN java -Djarmode=layertools -jar app.jar extract


##### Stage 2: A minimal docker image
FROM openjdk:11-jre-slim
WORKDIR application
COPY --from=builder extracted/dependencies/ ./
COPY --from=builder extracted/spring-boot-loader/ ./
COPY --from=builder extracted/snapshot-dependencies/ ./
COPY --from=builder extracted/application/ ./

#EXPOSE 80

ENTRYPOINT ["java", "org.springframework.boot.loader.JarLauncher"]