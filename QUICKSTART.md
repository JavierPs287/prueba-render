# 🚀 Quick Start Guide - Azure DevOps CI/CD

Guía rápida para poner en marcha el pipeline de CI/CD en 10 minutos.

---

## ⚡ Setup Rápido (10 minutos)

### Paso 1: Validar el Proyecto (2 min)

```powershell
# Ejecutar script de validación
.\validate-pipeline.ps1
```

✅ Si todo está verde, continúa al paso 2.

---

### Paso 2: Subir a GitHub (1 min)

```bash
git add .
git commit -m "chore: Add Azure DevOps CI/CD pipeline"
git push origin main
```

---

### Paso 3: Configurar Azure DevOps (3 min)

1. **Crear cuenta**: [https://dev.azure.com](https://dev.azure.com)
   
2. **Crear organización**: 
   - Nombre: `ESI-MEDIA-Org`
   
3. **Crear proyecto**:
   - Nombre: `ESI-MEDIA`
   - Visibility: Private

4. **Conectar GitHub**:
   - Project Settings → Service connections → New → GitHub
   - Autorizar y guardar

---

### Paso 4: Crear Pipeline (2 min)

1. **New Pipeline**:
   - Pipelines → New pipeline → GitHub
   
2. **Seleccionar repositorio**:
   - `JavierPs287/prueba-render`
   
3. **Existing Azure Pipelines YAML**:
   - Path: `/azure-pipelines.yml`
   
4. **Run**:
   - Click "Run" → ¡El pipeline comenzará!

---

### Paso 5: Variables Opcionales (2 min)

Si quieres deploy automático via API de Render:

1. **Obtener API Key de Render**:
   - [Render Dashboard](https://dashboard.render.com) → Account Settings → API Keys
   - Crear key: `Azure-DevOps-CI-CD`
   - Copiar: `rnd_xxxxx...`

2. **Obtener Service ID**:
   - En tu servicio de Render, la URL tiene: `https://dashboard.render.com/web/srv-xxxxx`
   - Copiar: `srv-xxxxx...`

3. **Añadir en Azure DevOps**:
   - Pipeline → Edit → Variables (esquina superior derecha)
   - Add:
     - `RENDER_API_KEY` = `rnd_xxxxx...` (marcar como Secret)
     - `RENDER_SERVICE_ID` = `srv-xxxxx...` (marcar como Secret)
   - Save

---

## 🎯 ¿Qué Hace el Pipeline?

```
Push to main → Azure DevOps detecta cambio
    ↓
Build Backend (Maven + Java 21)
    ↓
Build Frontend (npm + Angular)
    ↓
Run Tests (Backend + Frontend)
    ↓
Build Docker Image
    ↓
Deploy to Render
    ↓
Health Check
    ↓
✅ App Live!
```

**Duración total**: ~15-20 minutos

---

## 📊 Ver el Progreso

### En Azure DevOps

1. Ir a: **Pipelines** → Selecciona tu pipeline
2. Ver el run actual
3. Click en cada stage para ver logs

### Estados:

- 🟢 **Succeeded** - Todo OK
- 🔴 **Failed** - Error (revisar logs)
- 🟡 **Running** - En progreso
- 🔵 **Waiting** - Esperando aprobación

---

## 🌐 Acceder a tu App

Una vez completado:

**URL**: [https://esimedia-app.onrender.com](https://esimedia-app.onrender.com)

> ⚠️ **Nota**: Si usas el plan Free de Render, la primera carga puede tardar ~30 segundos (el servicio se "despierta").

---

## 🔄 Workflow Diario

### Hacer Cambios

```bash
# 1. Hacer cambios en el código
code .

# 2. Commitear
git add .
git commit -m "feat: Add new feature"

# 3. Push
git push origin main

# 4. Azure DevOps automáticamente:
#    - Ejecuta el pipeline
#    - Hace tests
#    - Despliega si todo OK
```

### Ver Resultados

1. Ve a Azure DevOps → Pipelines
2. Verás el pipeline ejecutándose
3. En ~15-20 min, tu app estará actualizada en Render

---

## 🐛 Si Algo Falla

### Tests Fallan

```bash
# Ejecutar localmente primero
cd be-esimedia && mvn test
cd fe-esimedia && npm test
```

### Build Falla

```bash
# Verificar que compila localmente
cd be-esimedia && mvn clean package
cd fe-esimedia && npm run build
```

### Deploy Falla

1. Verifica variables de entorno en Render
2. Revisa logs en Render dashboard
3. Verifica que MongoDB está accesible

---

## 📚 Documentación Completa

- **Setup detallado**: [AZURE_DEVOPS_SETUP.md](AZURE_DEVOPS_SETUP.md)
- **Deploy en Render**: [RENDER_DEPLOYMENT.md](RENDER_DEPLOYMENT.md)
- **Docker**: [DOCKER_README.md](DOCKER_README.md)

---

## ✅ Checklist

Antes de hacer push:

- [ ] `validate-pipeline.ps1` pasa sin errores
- [ ] Tests locales pasan
- [ ] Código commiteado
- [ ] Pipeline configurado en Azure DevOps
- [ ] Service connection con GitHub creada
- [ ] Variables de Render configuradas (opcional)

---

## 🎉 ¡Listo!

Tu proyecto ahora tiene:
- ✅ CI/CD automático
- ✅ Tests automáticos
- ✅ Deploy automático
- ✅ Health checks

**Cada push a `main` desplegará automáticamente tu app** 🚀

---

## 🆘 Ayuda Rápida

### Pipeline no se ejecuta

1. Verifica service connection con GitHub
2. Verifica que `azure-pipelines.yml` está en el repo
3. Verifica permisos del pipeline

### Deploy no funciona

1. Sin API Key: Render desplegará automáticamente desde GitHub
2. Con API Key: Verifica que `RENDER_API_KEY` y `RENDER_SERVICE_ID` estén configuradas

### App no carga

1. Espera 30 segundos (plan Free de Render)
2. Verifica logs en Render dashboard
3. Verifica variables de entorno en Render

---

**¿Dudas?** Revisa la [documentación completa](AZURE_DEVOPS_SETUP.md) o crea un [Issue](https://github.com/JavierPs287/prueba-render/issues).
