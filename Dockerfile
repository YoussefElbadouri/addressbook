# Stage 1: Build the application with Maven
FROM maven:3.8.5-openjdk-17 AS build

# Set the working directory in the container
WORKDIR /app

# Copy the pom.xml to download dependencies
COPY pom.xml .

# Download project dependencies
RUN mvn dependency:go-offline -B

# Copy the entire project source
COPY src ./src

# Build the project and skip tests for faster builds
RUN mvn package -DskipTests

# Stage 2: Create the runtime image
FROM openjdk:17-jdk-slim

# Set the working directory
WORKDIR /app

# Copy the built WAR file from the build stage
COPY --from=build /app/target/*.war app.war

# Expose the port used by the application
EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "app.war"]
