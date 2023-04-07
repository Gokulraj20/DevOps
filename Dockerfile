# Base image
FROM openjdk:11-jdk-slim

# Working dir
WORKDIR /app

# Copying jar file to the container
COPY java-app .

# Exposing the port
EXPOSE 8080

# Running the application
CMD ["java", "-jar", "java-app.jar"]