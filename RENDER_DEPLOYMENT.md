# 🚀 Guía de Despliegue en Render

Esta guía te ayudará a desplegar tu aplicación ESI-MEDIA en **Render** usando Docker.

---

## 📋 **Prerequisitos**

1. ✅ Cuenta en [Render](https://render.com) (gratuita)
2. ✅ Repositorio en GitHub con el código
3. ✅ Base de datos MongoDB (puede ser MongoDB Atlas - gratuito)

---

## 🔧 **Configuración Inicial**

### **Paso 1: Preparar el Repositorio GitHub**

Asegúrate de que estos archivos estén en tu repositorio:

```
✅ Dockerfile
✅ docker-compose.yml (opcional, no se usa en Render)
✅ .dockerignore
✅ render.yaml (configuración de Render)
✅ be-esimedia/ (Backend)
✅ fe-esimedia/ (Frontend)
```

**Comandos para subir los cambios:**

```bash
git add .
git commit -m "feat: Add Docker configuration for Render deployment"
git push origin main
```

---

## 🌐 **Despliegue en Render**

### **Opción 1: Despliegue Automático con Blueprint (Recomendado)**

1. **Conecta tu repositorio:**
   - Ve a [Render Dashboard](https://dashboard.render.com)
   - Click en **"New +"** → **"Blueprint"**
   - Conecta tu repositorio de GitHub: `JavierPs287/prueba-render`
   - Render detectará automáticamente el archivo `render.yaml`

2. **Configura las variables de entorno:**
   - En el dashboard, ve a tu servicio
   - Click en **"Environment"**
   - Añade/modifica estas variables:
   
   ```
   SPRING_DATA_MONGODB_URI = mongodb+srv://usuario:password@cluster.mongodb.net
   SPRING_DATA_MONGODB_DATABASE = esimedia_prod
   SERVER_PORT = 8081
   PORT = 8081
   JWT_SECRET = (se generará automáticamente)
   ```

3. **Deploy:**
   - Render comenzará a construir y desplegar automáticamente
   - El proceso tarda aproximadamente **5-10 minutos**

---

### **Opción 2: Despliegue Manual**

1. **Crear un nuevo Web Service:**
   - Ve a [Render Dashboard](https://dashboard.render.com)
   - Click en **"New +"** → **"Web Service"**
   - Conecta tu repositorio: `JavierPs287/prueba-render`

2. **Configuración del servicio:**
   ```
   Name: esimedia-app
   Region: Frankfurt (o el más cercano)
   Branch: main
   Runtime: Docker
   
   Dockerfile Path: ./Dockerfile
   Docker Context: .
   Docker Command: (dejar vacío, usa el CMD del Dockerfile)
   ```

3. **Plan:**
   - Selecciona **"Free"** (con limitaciones) o **"Starter"** ($7/mes)
   
4. **Variables de entorno:**
   
   Añade estas variables en la sección **"Environment Variables"**:
   
   | Key | Value | Notas |
   |-----|-------|-------|
   | `SPRING_DATA_MONGODB_URI` | `mongodb+srv://user:pass@...` | Tu URI de MongoDB |
   | `SPRING_DATA_MONGODB_DATABASE` | `esimedia_prod` | Nombre de tu BD |
   | `SERVER_PORT` | `8081` | Puerto interno |
   | `PORT` | `8081` | Puerto que Render espera |
   | `JWT_SECRET` | `tu_clave_secreta_jwt` | Genera una segura |

5. **Crear el servicio:**
   - Click en **"Create Web Service"**
   - Render comenzará el build automáticamente

---

## 🔐 **Configuración de MongoDB Atlas (Si no tienes BD)**

1. **Crear cluster gratuito:**
   - Ve a [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
   - Crea una cuenta gratuita
   - Crea un cluster M0 (gratuito)

2. **Configurar acceso:**
   - En **"Database Access"**, crea un usuario con contraseña
   - En **"Network Access"**, añade: `0.0.0.0/0` (permitir desde cualquier IP)

3. **Obtener URI de conexión:**
   - Click en **"Connect"** → **"Connect your application"**
   - Copia la URI: `mongodb+srv://<username>:<password>@cluster.mongodb.net`
   - Reemplaza `<username>` y `<password>` con tus credenciales

---

## 📊 **Monitoreo del Despliegue**

### **Ver el proceso de construcción:**

1. En el dashboard de Render, ve a tu servicio
2. Click en **"Logs"** para ver el proceso en tiempo real
3. Verás las 3 etapas del build:
   - ✅ Building frontend (Angular)
   - ✅ Building backend (Spring Boot)
   - ✅ Creating final image

### **Estados posibles:**

- 🟡 **Building** - Construyendo la imagen Docker
- 🟢 **Live** - Aplicación funcionando correctamente
- 🔴 **Build Failed** - Error en la construcción
- 🟠 **Deploy Failed** - Error al desplegar

---

## 🌐 **Acceder a tu Aplicación**

Una vez desplegada, Render te dará una URL:

```
https://esimedia-app.onrender.com
```

**Rutas disponibles:**
- Frontend: `https://esimedia-app.onrender.com/`
- Home: `https://esimedia-app.onrender.com/home`
- Login: `https://esimedia-app.onrender.com/login`
- Admin Menu: `https://esimedia-app.onrender.com/menu/admin`
- Register Creator: `https://esimedia-app.onrender.com/menu/admin/register/creator`

---

## ⚙️ **Configuración Adicional (Opcional)**

### **Custom Domain:**

1. En tu servicio, ve a **"Settings"**
2. Scroll hasta **"Custom Domain"**
3. Añade tu dominio (ej: `esimedia.tudominio.com`)
4. Configura los registros DNS según las instrucciones

### **Auto-Deploy:**

Render automáticamente despliega cuando haces push a la rama `main`:

```bash
git add .
git commit -m "Update feature"
git push origin main
# Render detectará el cambio y redesplegará automáticamente
```

### **Variables de Entorno Seguras:**

Para mayor seguridad, NO pongas credenciales en el código:

1. Ve a **"Environment"** → **"Environment Variables"**
2. Marca las variables sensibles como **"Secret"**
3. Render las ocultará en los logs

---

## 🐛 **Solución de Problemas**

### **Build Failed:**

```bash
# Ver logs completos en Render Dashboard
# Errores comunes:

1. Falta de memoria (Free tier tiene 512MB)
   Solución: Actualizar a plan Starter

2. Timeout en el build
   Solución: Optimizar el Dockerfile o actualizar plan

3. Error en Maven/npm
   Solución: Verificar dependencias en pom.xml/package.json
```

### **Deploy Failed:**

```bash
# Verificar:
1. PORT está configurado correctamente (8081)
2. MongoDB URI es válida y accesible
3. Variables de entorno están bien configuradas
```

### **Aplicación no responde:**

```bash
# En los logs, buscar:
- "Started BeEsimediaApplication" ✅
- Errores de conexión a MongoDB ❌
- OutOfMemoryError ❌
```

### **CORS Errors:**

Si el frontend tiene problemas de CORS, añade configuración en el backend:

```java
// Añadir en WebConfig.java o crear CorsConfig.java
@Override
public void addCorsMappings(CorsRegistry registry) {
    registry.addMapping("/api/**")
            .allowedOrigins("https://esimedia-app.onrender.com")
            .allowedMethods("GET", "POST", "PUT", "DELETE");
}
```

---

## 💰 **Costos**

### **Plan Free (Gratis):**
- ✅ 750 horas/mes
- ⚠️ Se "duerme" después de 15 min de inactividad
- ⚠️ Puede tardar ~30 segundos en despertar
- ✅ Ideal para demos y desarrollo

### **Plan Starter ($7/mes):**
- ✅ Siempre activo
- ✅ Sin tiempos de espera
- ✅ Más memoria y CPU
- ✅ Ideal para producción

---

## 📝 **Checklist de Despliegue**

Antes de desplegar, verifica:

- [ ] Dockerfile funciona localmente (`docker build -t test .`)
- [ ] Variables de entorno están configuradas
- [ ] MongoDB es accesible desde internet
- [ ] Puerto 8081 configurado correctamente
- [ ] Archivos Docker están en el repositorio
- [ ] Repository está en GitHub y es accesible
- [ ] render.yaml está configurado (opcional)

---

## 🔄 **Actualizar la Aplicación**

Para desplegar cambios:

```bash
# 1. Hacer cambios en el código
# 2. Commitear y pushear
git add .
git commit -m "Update: descripción del cambio"
git push origin main

# 3. Render desplegará automáticamente
# 4. Verificar en los logs que todo esté OK
```

---

## 📚 **Recursos Adicionales**

- [Documentación de Render](https://render.com/docs)
- [Render + Docker](https://render.com/docs/docker)
- [MongoDB Atlas Docs](https://docs.atlas.mongodb.com/)
- [Spring Boot on Render](https://render.com/docs/deploy-spring-boot)

---

## 🆘 **Soporte**

Si encuentras problemas:

1. Revisa los **logs** en el dashboard de Render
2. Verifica las **variables de entorno**
3. Prueba la aplicación **localmente** con Docker
4. Consulta la [comunidad de Render](https://community.render.com/)

---

**¡Listo para desplegar! 🚀**
