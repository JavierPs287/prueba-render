# ESI-MEDIA 🎬

[![Build Status](https://dev.azure.com/YOUR_ORG/ESI-MEDIA/_apis/build/status/ESI-MEDIA-Pipeline?branchName=main)](https://dev.azure.com/YOUR_ORG/ESI-MEDIA/_build/latest?definitionId=YOUR_DEFINITION_ID&branchName=main)
[![Deploy Status](https://img.shields.io/badge/Deploy-Render-46E3B7)](https://render.com)
[![Java](https://img.shields.io/badge/Java-21-orange)](https://www.oracle.com/java/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.5.6-green)](https://spring.io/projects/spring-boot)
[![Angular](https://img.shields.io/badge/Angular-Latest-red)](https://angular.io/)

Plataforma de gestión de contenido multimedia desarrollada con Spring Boot y Angular.

---

## 📋 Tabla de Contenidos

- [Características](#-características)
- [Tecnologías](#-tecnologías)
- [Requisitos Previos](#-requisitos-previos)
- [Instalación y Ejecución](#-instalación-y-ejecución)
- [CI/CD Pipeline](#-cicd-pipeline)
- [Despliegue](#-despliegue)
- [Documentación](#-documentación)
- [Contribuir](#-contribuir)

---

## ✨ Características

- 🎭 **Gestión de Usuarios**: Sistema completo de registro y autenticación
- 📺 **Gestión de Contenido**: Upload y administración de contenido multimedia
- 👥 **Roles y Permisos**: Admin, Creator, User
- 🔐 **Autenticación JWT**: Seguridad basada en tokens
- 📊 **Dashboard Administrativo**: Panel de control completo
- 🎨 **UI Moderna**: Interfaz responsive con Angular
- 🐳 **Dockerizado**: Fácil despliegue con Docker

---

## 🛠️ Tecnologías

### Backend
- **Java 21**
- **Spring Boot 3.5.6**
- **Spring Data MongoDB**
- **Spring Session**
- **Maven**

### Frontend
- **Angular** (Latest)
- **TypeScript**
- **RxJS**
- **Angular Material** (si aplica)

### Base de Datos
- **MongoDB Atlas**

### DevOps
- **Docker** & **Docker Compose**
- **Azure DevOps** (CI/CD)
- **Render** (Hosting)

---

## 📦 Requisitos Previos

- **Java**: JDK 21 o superior
- **Node.js**: v20.x o superior
- **Maven**: 3.8+ 
- **Docker**: 20.10+ (opcional, para ejecutar con Docker)
- **Git**: Para clonar el repositorio

---

## 🚀 Instalación y Ejecución

### Opción 1: Ejecución Local (Sin Docker)

#### Backend

```bash
# Navegar al directorio del backend
cd be-esimedia

# Instalar dependencias y compilar
mvn clean install

# Ejecutar la aplicación
mvn spring-boot:run

# O ejecutar el JAR
java -jar target/be-esimedia-0.0.1-SNAPSHOT.jar
```

El backend estará disponible en: `http://localhost:8081`

#### Frontend

```bash
# Navegar al directorio del frontend
cd fe-esimedia

# Instalar dependencias
npm install

# Ejecutar en modo desarrollo
npm start

# O build de producción
npm run build
```

El frontend estará disponible en: `http://localhost:4200`

---

### Opción 2: Ejecución con Docker

#### Usando Docker Compose (Recomendado)

```bash
# Construir y ejecutar
docker-compose up --build

# O en modo background
docker-compose up -d

# Ver logs
docker-compose logs -f

# Detener
docker-compose down
```

#### Usando Docker directo

```bash
# Construir la imagen
docker build -t esimedia-app .

# Ejecutar el contenedor
docker run -p 8081:8081 \
  -e SPRING_DATA_MONGODB_URI=your_mongodb_uri \
  -e SPRING_DATA_MONGODB_DATABASE=esimedia \
  esimedia-app
```

La aplicación estará disponible en: `http://localhost:8081`

---

### Opción 3: Script de PowerShell (Windows)

```powershell
# Ejecutar con Docker
.\run-docker.ps1

# O preparar para deploy
.\prepare-deploy.ps1
```

---

## 🔄 CI/CD Pipeline

Este proyecto utiliza **Azure DevOps** para integración continua y despliegue automático.

### Pipeline Overview

```
┌─────────────────────────────────────────────────────────┐
│ Developer Push to GitHub                                │
└───────────────┬─────────────────────────────────────────┘
                │
                ▼
┌─────────────────────────────────────────────────────────┐
│ Azure DevOps Pipeline Trigger                           │
└───────────────┬─────────────────────────────────────────┘
                │
                ▼
┌─────────────────────────────────────────────────────────┐
│ Stage 1: Build & Test                                   │
│   ├─ Backend (Maven, JUnit, JaCoCo)                     │
│   └─ Frontend (npm, Karma, Jasmine)                     │
└───────────────┬─────────────────────────────────────────┘
                │
                ▼
┌─────────────────────────────────────────────────────────┐
│ Stage 2: Code Quality (SonarQube - Optional)            │
└───────────────┬─────────────────────────────────────────┘
                │
                ▼
┌─────────────────────────────────────────────────────────┐
│ Stage 3: Docker Build (only on main)                    │
└───────────────┬─────────────────────────────────────────┘
                │
                ▼
┌─────────────────────────────────────────────────────────┐
│ Stage 4: Deploy to Render (with approval)               │
└───────────────┬─────────────────────────────────────────┘
                │
                ▼
┌─────────────────────────────────────────────────────────┐
│ Stage 5: Smoke Tests & Health Check                     │
└───────────────┬─────────────────────────────────────────┘
                │
                ▼
┌─────────────────────────────────────────────────────────┐
│ ✅ Application Live on Render                           │
└─────────────────────────────────────────────────────────┘
```

### Configurar el Pipeline

1. **Validar configuración local**:
   ```powershell
   .\validate-pipeline.ps1
   ```

2. **Seguir la guía de configuración**: Ver [AZURE_DEVOPS_SETUP.md](AZURE_DEVOPS_SETUP.md)

3. **Configurar variables secretas** en Azure DevOps:
   - `RENDER_API_KEY`
   - `RENDER_SERVICE_ID`

### Triggers

El pipeline se ejecuta automáticamente en:
- ✅ Push a `main` o `develop`
- ✅ Pull Requests hacia `main` o `develop`
- ✅ Manualmente desde Azure DevOps

---

## 🌐 Despliegue

### Despliegue en Render

La aplicación se despliega automáticamente en Render cuando se hace push a `main`.

**URL de Producción**: [https://esimedia-app.onrender.com](https://esimedia-app.onrender.com)

#### Despliegue Manual

Ver la guía completa: [RENDER_DEPLOYMENT.md](RENDER_DEPLOYMENT.md)

#### Despliegue Automático

El pipeline de Azure DevOps despliega automáticamente:
1. Build del proyecto
2. Construcción de imagen Docker
3. Push a Render vía API
4. Health check automático

---

## 📚 Documentación

- **[AZURE_DEVOPS_SETUP.md](AZURE_DEVOPS_SETUP.md)**: Configuración completa del pipeline CI/CD
- **[RENDER_DEPLOYMENT.md](RENDER_DEPLOYMENT.md)**: Guía de despliegue en Render
- **[DOCKER_README.md](DOCKER_README.md)**: Documentación de Docker

### Endpoints API (Backend)

```
Base URL: http://localhost:8081 (local) o https://esimedia-app.onrender.com (producción)

Autenticación:
  POST   /api/auth/login
  POST   /api/auth/register
  
Usuarios:
  GET    /api/users
  GET    /api/users/{id}
  PUT    /api/users/{id}
  DELETE /api/users/{id}
  
Contenido:
  GET    /api/content
  POST   /api/content
  GET    /api/content/{id}
  PUT    /api/content/{id}
  DELETE /api/content/{id}
```

### Rutas Frontend

```
/                           → Página principal
/home                       → Home
/login                      → Login de usuario
/menu/admin                 → Menú admin
/menu/admin/register/user   → Registro de usuario
/menu/admin/register/creator → Registro de creador
/menu/admin/users           → Gestión de usuarios
/menu/creator               → Menú creador
/menu/creator/upload        → Upload de contenido
```

---

## 🧪 Tests

### Backend Tests

```bash
cd be-esimedia

# Ejecutar todos los tests
mvn test

# Con reporte de cobertura
mvn test jacoco:report

# Ver reporte: target/site/jacoco/index.html
```

### Frontend Tests

```bash
cd fe-esimedia

# Ejecutar tests
npm test

# Con cobertura
npm run test -- --code-coverage

# Ver reporte: coverage/index.html
```

---

## 🔍 Análisis de Código

### SonarQube (Backend)

```bash
cd be-esimedia
mvn sonar:sonar \
  -Dsonar.projectKey=esimedia-backend \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=your_token
```

### SonarQube (Frontend)

```bash
cd fe-esimedia
npm run sonar
```

---

## 🐛 Troubleshooting

### Error: "Cannot connect to MongoDB"

**Solución**: Verifica la variable `SPRING_DATA_MONGODB_URI` en `application.properties` o como variable de entorno.

### Error: "Port 8081 already in use"

**Solución**: 
```bash
# Windows
netstat -ano | findstr :8081
taskkill /PID <PID> /F

# Linux/Mac
lsof -ti:8081 | xargs kill -9
```

### Error de CORS en el Frontend

**Solución**: Configurar CORS en el backend (ya debería estar configurado en `WebConfig.java`).

---

## 📊 Monitoreo

### Logs en Render

```bash
# Ver desde el dashboard de Render
https://dashboard.render.com/web/your-service-id/logs

# O usando Render CLI
render logs -f
```

### Métricas en Azure DevOps

- Pipeline runs: `https://dev.azure.com/your-org/ESI-MEDIA/_build`
- Test results: Ver en cada pipeline run
- Code coverage: Ver en cada pipeline run

---

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

### Convenciones de Commits

Usamos [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: Nueva característica
fix: Corrección de bug
docs: Cambios en documentación
style: Formateo, puntos y comas, etc.
refactor: Refactorización de código
test: Añadir o modificar tests
chore: Tareas de mantenimiento
```

---

## 📝 Variables de Entorno

### Backend (application.properties)

```properties
# MongoDB
spring.data.mongodb.uri=mongodb+srv://user:pass@cluster.mongodb.net
spring.data.mongodb.database=esimedia

# Server
server.port=8081

# JWT
jwt.secret=your_secret_key
jwt.expiration=86400000
```

### Docker

```bash
# En docker-compose.yml o .env
SPRING_DATA_MONGODB_URI=mongodb+srv://...
SPRING_DATA_MONGODB_DATABASE=esimedia
SERVER_PORT=8081
JWT_SECRET=your_secret
```

### Azure DevOps (Pipeline Variables)

```yaml
# Configurar en Azure DevOps UI
RENDER_API_KEY=rnd_xxxxx
RENDER_SERVICE_ID=srv_xxxxx
```

---

## 📄 Licencia

Este proyecto es parte de un trabajo académico de la ESI-UCLM.

---

## 👥 Autores

- **Javier** - [JavierPs287](https://github.com/JavierPs287)

---

## 🙏 Agradecimientos

- Universidad de Castilla-La Mancha (UCLM)
- Escuela Superior de Informática (ESI)
- Profesores y colaboradores del proyecto

---

## 📞 Soporte

Si encuentras algún problema o tienes preguntas:

1. Revisa la [documentación](#-documentación)
2. Busca en [Issues](https://github.com/JavierPs287/prueba-render/issues)
3. Crea un nuevo [Issue](https://github.com/JavierPs287/prueba-render/issues/new)

---

**¡Desarrollado con ❤️ en la ESI-UCLM!** 🎓