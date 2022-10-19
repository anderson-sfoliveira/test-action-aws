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
FROM adoptopenjdk:11-jre-hotspot as builder
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} application.jar
RUN java -Djarmode=layertools -jar application.jar extract

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


#### Stage 1: Build the application
#FROM maven:3.6.3-openjdk-11-slim as build
#WORKDIR /app
#COPY pom.xml .
#RUN mvn dependency:go-offline -B
#
#COPY src src
#RUN mvn package -DskipTests
#RUN mkdir -p target/dependency && (cd target/dependency; jar -xf ../*.jar)
#
##### Stage 2: A minimal docker image with command to run the app
#FROM openjdk:11-jre-slim
#
#ARG DEPENDENCY=/app/target/dependency
#
## Copy project dependencies from the build stage
#COPY --from=build ${DEPENDENCY}/BOOT-INF/lib /app/lib
#COPY --from=build ${DEPENDENCY}/META-INF /app/META-INF
#COPY --from=build ${DEPENDENCY}/BOOT-INF/classes /app
#
#ENTRYPOINT ["java", "-cp", "app:app/lib/*", "com.example.testactionaws.TestActionAwsApplication"]


##### Stage 1: Extract the application
#FROM openjdk:11-jre-slim as builder
#WORKDIR extracted
#ADD ./target/*.jar app.jar
#RUN java -Djarmode=layertools -jar app.jar extract
#
#
###### Stage 2: A minimal docker image
#FROM openjdk:11-jre-slim
#WORKDIR application
#COPY --from=builder extracted/dependencies/ ./
#COPY --from=builder extracted/spring-boot-loader/ ./
#COPY --from=builder extracted/snapshot-dependencies/ ./
#COPY --from=builder extracted/application/ ./
#
##EXPOSE 80
#
#ENTRYPOINT ["java", "org.springframework.boot.loader.JarLauncher"]