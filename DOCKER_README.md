# 🐳 ESI-MEDIA - Guía de Docker

Esta guía explica cómo ejecutar la aplicación ESI-MEDIA dockerizada (Backend Spring Boot + Frontend Angular en un único contenedor).

## 📋 Prerequisitos

Antes de comenzar, asegúrate de tener instalado:

- **Docker Desktop** (Windows/Mac) o **Docker Engine** (Linux)
  - Descarga desde: https://www.docker.com/products/docker-desktop
- **Docker Compose** (incluido con Docker Desktop)

Para verificar la instalación, ejecuta:
```powershell
docker --version
docker-compose --version
```

## 🏗️ Arquitectura

El Dockerfile utiliza una estrategia **multi-stage** que optimiza el tamaño de la imagen final:

1. **Etapa 1 (frontend-build)**: Compila la aplicación Angular
2. **Etapa 2 (backend-build)**: Compila la aplicación Spring Boot con Maven
3. **Etapa 3 (imagen final)**: Combina ambos en una imagen ligera con solo el runtime de Java

El frontend compilado se sirve como recursos estáticos desde el backend Spring Boot.

## 🚀 Opciones de Ejecución

### Opción 1: Usando Docker Compose (Recomendado)

Esta es la forma más sencilla de ejecutar la aplicación.

#### Construir y ejecutar:
```powershell
# Desde el directorio raíz del proyecto (donde está el docker-compose.yml)
docker-compose up --build
```

#### Ejecutar en segundo plano:
```powershell
docker-compose up -d
```

#### Ver los logs:
```powershell
docker-compose logs -f
```

#### Detener la aplicación:
```powershell
docker-compose down
```

### Opción 2: Usando Docker directamente

#### 1. Construir la imagen:
```powershell
docker build -t esimedia-app:latest .
```

#### 2. Ejecutar el contenedor:
```powershell
docker run -d `
  --name esimedia-container `
  -p 8081:8081 `
  -e SPRING_DATA_MONGODB_URI="mongodb+srv://prueba:prueba@esimediadev.krctjsb.mongodb.net" `
  -e SPRING_DATA_MONGODB_DATABASE="esimedia_test" `
  esimedia-app:latest
```

#### 3. Ver los logs:
```powershell
docker logs -f esimedia-container
```

#### 4. Detener el contenedor:
```powershell
docker stop esimedia-container
docker rm esimedia-container
```

## 🌐 Acceder a la Aplicación

Una vez que el contenedor esté en ejecución:

- **URL de la aplicación**: http://localhost:8081
- El frontend Angular se sirve desde la raíz
- El backend API está disponible en http://localhost:8081/api/*

## ⚙️ Configuración de Variables de Entorno

Puedes personalizar la configuración mediante variables de entorno:

### En docker-compose.yml:
```yaml
environment:
  - SPRING_DATA_MONGODB_URI=tu_uri_de_mongodb
  - SPRING_DATA_MONGODB_DATABASE=tu_base_de_datos
  - SERVER_PORT=8081
  - JWT_SECRET=tu_clave_secreta_jwt
```

### Con Docker run:
```powershell
docker run -d `
  -p 8081:8081 `
  -e SPRING_DATA_MONGODB_URI="mongodb://..." `
  -e SPRING_DATA_MONGODB_DATABASE="esimedia_prod" `
  -e JWT_SECRET="nueva_clave_secreta" `
  esimedia-app:latest
```

## 🔧 Comandos Útiles

### Ver contenedores en ejecución:
```powershell
docker ps
```

### Ver todas las imágenes:
```powershell
docker images
```

### Entrar al contenedor (debug):
```powershell
docker exec -it esimedia-container sh
```

### Ver uso de recursos:
```powershell
docker stats esimedia-container
```

### Limpiar contenedores e imágenes no utilizadas:
```powershell
docker system prune -a
```

## 🔄 Reconstruir la Aplicación

Si realizas cambios en el código:

### Con Docker Compose:
```powershell
docker-compose down
docker-compose up --build
```

### Con Docker:
```powershell
docker stop esimedia-container
docker rm esimedia-container
docker rmi esimedia-app:latest
docker build -t esimedia-app:latest .
docker run -d --name esimedia-container -p 8081:8081 esimedia-app:latest
```

## 📦 Información de la Imagen

- **Tamaño aproximado**: ~350-400 MB (optimizado con multi-stage build)
- **Base image**: eclipse-temurin:21-jre-alpine
- **Puerto expuesto**: 8081
- **Arquitectura**: x86_64/arm64 (depende del host)

## 🐛 Solución de Problemas

### El contenedor no inicia:
```powershell
# Ver los logs del contenedor
docker logs esimedia-container

# Ver los logs de docker-compose
docker-compose logs
```

### Puerto 8081 ya en uso:
```powershell
# Cambiar el puerto en docker-compose.yml
ports:
  - "8082:8081"  # Usa 8082 externamente

# O encontrar qué proceso usa el puerto
netstat -ano | findstr :8081
```

### Error de conexión a MongoDB:
Verifica que la URI de MongoDB sea correcta y que tengas acceso a internet (si usas MongoDB Atlas).

### La aplicación Angular no carga:
Verifica que:
1. El build de Angular se completó correctamente (revisa los logs del build)
2. Los archivos estáticos están en `/app/static/` dentro del contenedor
3. La configuración de WebConfig esté correcta

## 📝 Notas de Seguridad

⚠️ **IMPORTANTE**: Las credenciales de MongoDB en los archivos son de ejemplo. 

Para producción:
1. Usa variables de entorno
2. Utiliza Docker secrets
3. No incluyas credenciales en el código fuente

Ejemplo con archivo .env:
```powershell
# Crear archivo .env
echo "SPRING_DATA_MONGODB_URI=mongodb+srv://user:pass@..." > .env
echo "JWT_SECRET=clave_super_secreta" >> .env

# Docker Compose cargará automáticamente las variables del .env
docker-compose up
```

## 📚 Recursos Adicionales

- [Documentación oficial de Docker](https://docs.docker.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/)
- [Spring Boot in Docker](https://spring.io/guides/gs/spring-boot-docker/)
- [Angular Deployment](https://angular.io/guide/deployment)

## 🆘 Soporte

Si encuentras problemas, verifica:
1. Los logs del contenedor
2. Que Docker Desktop esté ejecutándose
3. Que no haya conflictos de puertos
4. Que tengas suficiente espacio en disco para las imágenes
