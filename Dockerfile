# Étape 1 : Construction de l'application avec Maven
FROM maven:3.8.5-openjdk-17 AS build

# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Copier le fichier pom.xml et télécharger les dépendances
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copier tout le code source et construire le projet
COPY src ./src
RUN mvn package -DskipTests

# Étape 2 : Création de l'image finale avec OpenJDK
FROM openjdk:17-jdk-slim

# Définir le répertoire de travail
WORKDIR /app

# Copier le fichier JAR construit depuis l'étape précédente
COPY --from=build /app/target/*.jar app.jar

# Exposer le port utilisé par l'application
EXPOSE 8080

# Démarrer l'application Java
CMD ["java", "-jar", "app.jar"]
