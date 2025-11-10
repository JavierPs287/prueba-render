# 🔄 Configuración de Azure DevOps Pipeline para ESI-MEDIA

Esta guía te ayudará a configurar el pipeline de CI/CD en Azure DevOps para despliegue automático en Render.

---

## 📋 **Prerequisitos**

1. ✅ Cuenta en [Azure DevOps](https://dev.azure.com) (gratuita)
2. ✅ Repositorio en GitHub: `JavierPs287/prueba-render`
3. ✅ Aplicación desplegada en [Render](https://render.com)
4. ✅ API Key de Render (opcional, para deploys automáticos)

---

## 🚀 **Paso 1: Crear Proyecto en Azure DevOps**

### **1.1. Crear Organización (si no tienes una)**

1. Ve a [https://dev.azure.com](https://dev.azure.com)
2. Inicia sesión con tu cuenta Microsoft/GitHub
3. Click en **"New organization"**
4. Nombre sugerido: `ESI-MEDIA-Org`

### **1.2. Crear Proyecto**

1. Click en **"New project"**
2. Configuración:
   ```
   Project name: ESI-MEDIA
   Description: Plataforma de gestión de contenido multimedia
   Visibility: Private (o Public según prefieras)
   Version control: Git
   Work item process: Agile
   ```
3. Click en **"Create"**

---

## 🔗 **Paso 2: Conectar con GitHub**

### **2.1. Service Connection**

1. En tu proyecto, ve a **"Project Settings"** (esquina inferior izquierda)
2. En la sección **"Pipelines"**, click en **"Service connections"**
3. Click en **"New service connection"**
4. Selecciona **"GitHub"**
5. Autoriza Azure DevOps para acceder a tu GitHub
6. Nombre de la conexión: `GitHub-ESI-MEDIA`
7. Click en **"Save"**

---

## ⚙️ **Paso 3: Crear el Pipeline**

### **3.1. Importar Pipeline**

1. En tu proyecto, ve a **"Pipelines"**
2. Click en **"New pipeline"** (o **"Create Pipeline"**)
3. Selecciona **"GitHub"** como fuente
4. Selecciona tu repositorio: `JavierPs287/prueba-render`
5. Azure detectará automáticamente el archivo `azure-pipelines.yml`
6. Click en **"Run"**

### **3.2. Alternativa: Configuración Manual**

Si prefieres configurar manualmente:

1. En **"Pipelines"**, click en **"New pipeline"**
2. Selecciona **"GitHub"**
3. Autoriza y selecciona el repositorio
4. Selecciona **"Existing Azure Pipelines YAML file"**
5. Ruta: `/azure-pipelines.yml`
6. Click en **"Continue"** y luego **"Run"**

---

## 🔐 **Paso 4: Configurar Variables de Entorno**

### **4.1. Variables Secretas (Recomendado para Deploy Automático)**

Para que Azure DevOps pueda desplegar automáticamente en Render:

1. En **"Pipelines"**, selecciona tu pipeline
2. Click en **"Edit"**
3. En la esquina superior derecha, click en **"Variables"**
4. Añade estas variables:

| Variable | Valor | Tipo | Notas |
|----------|-------|------|-------|
| `RENDER_API_KEY` | `rnd_xxxxx...` | Secret | API Key de Render |
| `RENDER_SERVICE_ID` | `srv-xxxxx...` | Secret | ID del servicio en Render |

**Marcar ambas como "Secret" (candado)** ✅

### **4.2. Obtener API Key de Render**

1. Ve a [Render Dashboard](https://dashboard.render.com)
2. Click en tu avatar → **"Account Settings"**
3. En el menú izquierdo, click en **"API Keys"**
4. Click en **"Create API Key"**
5. Nombre: `Azure-DevOps-CI-CD`
6. Copia el key (ejemplo: `rnd_abc123...`)
7. Pégalo en Azure DevOps como `RENDER_API_KEY`

### **4.3. Obtener Service ID**

1. En Render, ve a tu servicio **"esimedia-app"**
2. En la URL verás algo como: `https://dashboard.render.com/web/srv-xxxxx`
3. Copia el ID (ejemplo: `srv-cp123abc...`)
4. Pégalo en Azure DevOps como `RENDER_SERVICE_ID`

---

## 🏗️ **Paso 5: Configurar Environments**

Para aprovechar el deployment tracking:

1. En tu proyecto, ve a **"Pipelines"** → **"Environments"**
2. Click en **"New environment"**
3. Configuración:
   ```
   Name: production
   Description: Production environment on Render
   Resource: None
   ```
4. Click en **"Create"**

### **Opcional: Añadir Aprobaciones**

Si quieres que alguien apruebe antes de desplegar:

1. En el environment **"production"**, click en los 3 puntos → **"Approvals and checks"**
2. Click en **"Approvals"**
3. Añade los aprobadores necesarios
4. Click en **"Create"**

---

## 📊 **Paso 6: Ejecutar el Pipeline**

### **6.1. Trigger Manual**

1. Ve a **"Pipelines"**
2. Selecciona tu pipeline
3. Click en **"Run pipeline"**
4. Selecciona la rama: `main`
5. Click en **"Run"**

### **6.2. Trigger Automático**

El pipeline se ejecutará automáticamente cuando:
- ✅ Hagas `git push` a la rama `main`
- ✅ Hagas `git push` a la rama `develop`
- ✅ Crees un Pull Request hacia `main` o `develop`

```bash
# Ejemplo de uso
git add .
git commit -m "feat: Add new feature"
git push origin main

# Azure DevOps detectará el cambio y ejecutará el pipeline automáticamente
```

---

## 📈 **Entendiendo las Etapas del Pipeline**

El pipeline tiene **5 etapas principales**:

### **Stage 1: Build and Test** 🏗️
- **Backend Job**: 
  - Configura Java 21
  - Ejecuta Maven build
  - Corre los tests del backend
  - Genera reportes de cobertura (JaCoCo)
- **Frontend Job**:
  - Configura Node.js 20
  - Instala dependencias npm
  - Ejecuta lint
  - Corre tests de Angular
  - Build de producción

⏱️ **Duración estimada**: 5-8 minutos

### **Stage 2: Code Quality** 📊
- Análisis de código con SonarQube (opcional)
- Requiere configuración adicional de SonarQube/SonarCloud

⏱️ **Duración estimada**: 2-3 minutos

### **Stage 3: Docker Build** 🐳
- Construye la imagen Docker
- Solo se ejecuta en la rama `main`

⏱️ **Duración estimada**: 3-5 minutos

### **Stage 4: Deploy to Render** 🚀
- Despliega automáticamente en Render
- Usa la API de Render (si está configurada)
- Requiere aprobación (si está configurada)

⏱️ **Duración estimada**: 1-2 minutos + tiempo de deploy en Render

### **Stage 5: Smoke Tests** ✅
- Verifica que la aplicación esté respondiendo
- Health check básico

⏱️ **Duración estimada**: 1 minuto

**Total estimado**: ~15-20 minutos

---

## 🔍 **Monitoreo del Pipeline**

### **Ver el Progreso en Tiempo Real**

1. Ve a **"Pipelines"** → Selecciona tu pipeline
2. Click en el run actual
3. Verás el progreso de cada stage y job
4. Click en cualquier job para ver los logs detallados

### **Estados Posibles**

- 🟢 **Succeeded** - Todo correcto
- 🔴 **Failed** - Hay un error
- 🟡 **Running** - En ejecución
- ⚪ **Queued** - En cola
- 🔵 **Waiting** - Esperando aprobación

### **Reportes Disponibles**

El pipeline genera varios reportes:

1. **Test Results**: 
   - Click en el run → **"Tests"** tab
   - Ver tests pasados/fallidos

2. **Code Coverage**:
   - Click en el run → **"Code Coverage"** tab
   - Ver % de cobertura del código

3. **Artifacts**:
   - Click en el run → **"Artifacts"**
   - Descargar JARs, builds, etc.

---

## 🐛 **Solución de Problemas Comunes**

### **❌ Error: "GitHub service connection not found"**

**Solución**:
1. Ve a **"Project Settings"** → **"Service connections"**
2. Crea la conexión con GitHub
3. Vuelve a ejecutar el pipeline

### **❌ Error: "RENDER_API_KEY variable not found"**

**Solución**:
1. Ve a **"Pipelines"** → Edita el pipeline → **"Variables"**
2. Añade `RENDER_API_KEY` como variable secreta
3. Si no quieres usar la API, el deploy automático de Render funcionará igual

### **❌ Error: "Maven build failed"**

**Causas comunes**:
- Dependencias faltantes
- Tests fallando
- Problemas de compilación

**Solución**:
```bash
# Probar localmente primero
cd be-esimedia
mvn clean package
mvn test
```

### **❌ Error: "npm install failed"**

**Solución**:
```bash
# Probar localmente
cd fe-esimedia
npm install
npm run build
```

### **⚠️ Warning: "Tests failed but pipeline continues"**

El pipeline está configurado con `continueOnError: true` en algunos tests.
Para hacerlo más estricto, edita `azure-pipelines.yml`:

```yaml
# Cambiar:
continueOnError: true
# Por:
continueOnError: false
```

---

## 🎯 **Optimizaciones Recomendadas**

### **1. Cache de Dependencias** ✅ (Ya configurado)

El pipeline usa cache para:
- Maven: Acelera builds del backend
- npm: Acelera builds del frontend

### **2. Builds Paralelos** ✅ (Ya configurado)

Backend y Frontend se buildan en paralelo = más rápido

### **3. Conditional Stages** ✅ (Ya configurado)

Ciertas etapas solo corren en `main`:
- Docker Build
- Deploy to Render

### **4. Añadir Notificaciones (Opcional)**

Para recibir notificaciones en Teams/Slack:

1. Ve a **"Project Settings"** → **"Service connections"**
2. Crea conexión con Teams o Slack
3. Añade al pipeline:

```yaml
# Al final del pipeline
- task: PublishPipelineMetadata@0
  displayName: 'Publish Pipeline Metadata'

# O usa una extensión de marketplace:
# https://marketplace.visualstudio.com/azuredevops
```

---

## 📊 **Métricas y Dashboards**

### **Ver Estadísticas del Pipeline**

1. Ve a **"Pipelines"** → **"Analytics"**
2. Verás:
   - Tasa de éxito
   - Duración promedio
   - Tendencias de failures
   - Test pass rate

### **Crear Dashboard Personalizado**

1. Ve a **"Overview"** → **"Dashboards"**
2. Click en **"New Dashboard"**
3. Añade widgets:
   - Pipeline status
   - Test results
   - Code coverage
   - Release status

---

## 🔄 **Workflow Completo**

```
Developer makes changes
    ↓
git commit & push to GitHub
    ↓
Azure DevOps Pipeline triggers
    ↓
Stage 1: Build & Test (Backend + Frontend in parallel)
    ↓
Stage 2: Code Quality Analysis
    ↓
Stage 3: Docker Build (only on main branch)
    ↓
Stage 4: Deploy to Render (with approval if configured)
    ↓
Stage 5: Smoke Tests
    ↓
✅ Application deployed and verified
    ↓
Render serves the updated application
```

---

## 📚 **Recursos Adicionales**

- [Azure Pipelines Documentation](https://docs.microsoft.com/en-us/azure/devops/pipelines/)
- [YAML Schema Reference](https://docs.microsoft.com/en-us/azure/devops/pipelines/yaml-schema/)
- [Render API Documentation](https://render.com/docs/api)
- [Azure DevOps Marketplace](https://marketplace.visualstudio.com/azuredevops)

---

## 🆘 **Soporte**

Si encuentras problemas:

1. **Revisa los logs** del pipeline en Azure DevOps
2. **Verifica las variables** de entorno
3. **Prueba localmente** antes de hacer push
4. **Consulta la documentación** oficial
5. **Contacta al equipo** si el problema persiste

---

## ✅ **Checklist de Configuración**

Antes de ejecutar el pipeline, verifica:

- [ ] Proyecto creado en Azure DevOps
- [ ] Service connection con GitHub configurada
- [ ] Pipeline importado y configurado
- [ ] Variables de entorno añadidas (opcional)
- [ ] Environment "production" creado
- [ ] Aprobaciones configuradas (opcional)
- [ ] Repositorio sincronizado con GitHub
- [ ] Archivo `azure-pipelines.yml` en la raíz del proyecto
- [ ] Render service activo y funcionando

---

## 🎉 **¡Listo para CI/CD!**

Tu pipeline de Azure DevOps está configurado y listo para:
- ✅ Builds automáticos en cada push
- ✅ Tests automáticos
- ✅ Análisis de código
- ✅ Despliegue automático en Render
- ✅ Verificación post-deploy

**Ahora cada vez que hagas push a `main`, tu aplicación se desplegará automáticamente en Render** 🚀

---

**Última actualización**: Noviembre 2025
