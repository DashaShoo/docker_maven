# Этап сборки
FROM maven:3.8.6-openjdk-11 AS build
WORKDIR /app
COPY . .
RUN mvn clean package

# Этап запуска
FROM openjdk:11-jre-slim
COPY --from=build /app/target/docker-maven-example-1.0-SNAPSHOT.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]