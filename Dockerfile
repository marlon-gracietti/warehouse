# Use an official Maven image to build the project
FROM maven:3.8.1-openjdk-11 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the pom.xml file and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy the entire project source code into the container
COPY src ./src

# Build the project and package it into a JAR file
RUN mvn clean package -DskipTests

# Use an official OpenJDK runtime as the base image for the final container
FROM openjdk:11-jre-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the JAR file from the build stage to the runtime stage
COPY --from=build /app/target/*.jar /app/app.jar

# Expose the port the application will run on (default for Spring Boot is 8080)
EXPOSE 8080

# Run the JAR file
CMD ["java", "-jar", "/app/app.jar"]
