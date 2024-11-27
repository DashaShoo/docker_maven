# Используем образ Maven для сборки приложения
FROM maven:3.8.4-openjdk-11 as builder

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем pom.xml и загружаем зависимости
COPY pom.xml .
RUN mvn dependency:go-offline

# Копируем исходный код и собираем приложение
COPY App.java .
RUN mvn clean package -Dmaven.test.skip=true

# Используем более легкий образ для запуска приложения
FROM openjdk:11-jre-slim

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем скомпилированный JAR файл из предыдущего образа
COPY --from=builder /app/target/docker_maven-1.0-SNAPSHOT.jar app.jar

# Открываем порт для приложения (если необходимо)
EXPOSE 8080

# Команда для запуска приложения
ENTRYPOINT ["java", "-jar", "/app/app.jar"]