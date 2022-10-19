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


#### Stage 1: Build the application
FROM maven:3.6.3-openjdk-11-slim as build

# Set the current working directory inside the image
WORKDIR /app

# Copy maven executable to the image
#COPY mvnw .
#COPY .mvn .mvn

# Copy the pom.xml file
COPY pom.xml .

# Build all the dependencies in preparation to go offline.
# This is a separate step so the dependencies will be cached unless
# the pom.xml file has changed.
RUN mvn dependency:go-offline -B

# Copy the project source
COPY src src

# Package the application
RUN mvn package -DskipTests
RUN mkdir -p target/dependency && (cd target/dependency; jar -xf ../*.jar)

#### Stage 2: A minimal docker image with command to run the app
FROM openjdk:11-jre-slim

ARG DEPENDENCY=/app/target/dependency

# Copy project dependencies from the build stage
COPY --from=build ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY --from=build ${DEPENDENCY}/META-INF /app/META-INF
COPY --from=build ${DEPENDENCY}/BOOT-INF/classes /app

ENTRYPOINT ["java", "-cp", "app:app/lib/*", "com.example.testactionaws.TestActionAwsApplication"]
