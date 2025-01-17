# Build stage
FROM maven:3.8.5-openjdk-17 AS build

WORKDIR /app

# Copy the pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy the source code and build the project
COPY src ./src
RUN mvn clean package -DskipTests

# Runtime stage
FROM openjdk:17-jdk-slim

WORKDIR /app
COPY --from=build /app/target/*.war app.war
EXPOSE 8080
CMD ["java", "-jar", "app.war"]
