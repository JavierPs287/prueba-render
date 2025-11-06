# Multi-stage Dockerfile para ESI-MEDIA
# Etapa 1: Build del Frontend (Angular)
FROM node:20-alpine AS frontend-build

WORKDIR /app/frontend

# Copiar archivos de configuración de npm
COPY fe-esimedia/package*.json ./

# Instalar dependencias
RUN npm ci

# Copiar el código fuente del frontend
COPY fe-esimedia/ ./

# Construir la aplicación Angular para producción
RUN npm run build

# Etapa 2: Build del Backend (Spring Boot)
FROM maven:3.9-eclipse-temurin-21-alpine AS backend-build

WORKDIR /app/backend

# Copiar archivos de configuración de Maven
COPY be-esimedia/pom.xml ./
COPY be-esimedia/mvnw ./
COPY be-esimedia/mvnw.cmd ./
COPY be-esimedia/.mvn ./.mvn

# Descargar dependencias (esta capa se cachea si no cambia el pom.xml)
RUN mvn dependency:go-offline -B

# Copiar el código fuente del backend
COPY be-esimedia/src ./src

# Construir el JAR de la aplicación
RUN mvn clean package -DskipTests

# Etapa 3: Imagen final de ejecución
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# Crear el directorio para recursos estáticos
RUN mkdir -p /app/public

# Copiar el JAR del backend desde la etapa de build
COPY --from=backend-build /app/backend/target/*.jar app.jar

# Copiar los archivos estáticos del frontend al directorio público
COPY --from=frontend-build /app/frontend/dist/fe-esimedia/browser /app/public

# Exponer el puerto del backend (que también servirá el frontend)
EXPOSE 8081

# Variables de entorno (pueden ser sobreescritas al ejecutar el contenedor)
ENV SPRING_DATA_MONGODB_URI=mongodb+srv://prueba:prueba@esimediadev.krctjsb.mongodb.net
ENV SPRING_DATA_MONGODB_DATABASE=esimedia_test
ENV SERVER_PORT=8081
ENV PORT=8081

# Comando para ejecutar la aplicación
# Usar la variable PORT si está disponible (Render la proporciona)
ENTRYPOINT ["sh", "-c", "java -Dserver.port=${PORT:-8081} -jar app.jar"]
