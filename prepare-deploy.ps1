# Script para preparar el repositorio para despliegue en Render
# Uso: .\prepare-deploy.ps1

param(
    [string]$CommitMessage = "chore: Prepare for Render deployment"
)

$ErrorActionPreference = "Stop"

function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

Write-ColorOutput "`n🚀 Preparando Repositorio para Render`n" "Cyan"

# 1. Verificar que estamos en el directorio correcto
Write-ColorOutput "📁 Verificando directorio..." "Yellow"
if (-not (Test-Path ".\Dockerfile")) {
    Write-ColorOutput "❌ Error: No se encuentra Dockerfile. Ejecuta este script desde la raíz del proyecto." "Red"
    exit 1
}
Write-ColorOutput "✅ Directorio correcto`n" "Green"

# 2. Verificar archivos necesarios
Write-ColorOutput "📋 Verificando archivos necesarios..." "Yellow"
$requiredFiles = @(
    "Dockerfile",
    "render.yaml",
    ".dockerignore",
    "RENDER_DEPLOYMENT.md"
)

$allFilesExist = $true
foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-ColorOutput "  ✅ $file" "Green"
    } else {
        Write-ColorOutput "  ❌ $file - FALTA" "Red"
        $allFilesExist = $false
    }
}

if (-not $allFilesExist) {
    Write-ColorOutput "`n❌ Faltan archivos necesarios. Por favor, créalos primero." "Red"
    exit 1
}
Write-ColorOutput ""

# 3. Verificar estado de Git
Write-ColorOutput "🔍 Verificando estado de Git..." "Yellow"
$gitStatus = git status --porcelain
if ($gitStatus) {
    Write-ColorOutput "📝 Archivos modificados detectados:`n" "Yellow"
    git status -s
    Write-ColorOutput ""
} else {
    Write-ColorOutput "✅ No hay cambios para commitear`n" "Green"
    Write-ColorOutput "ℹ️  El repositorio ya está actualizado." "Cyan"
    exit 0
}

# 4. Añadir archivos
Write-ColorOutput "➕ Añadiendo archivos al staging..." "Yellow"
git add Dockerfile
git add render.yaml
git add .dockerignore
git add RENDER_DEPLOYMENT.md
git add DOCKER_README.md
git add .env.example
git add .gitignore
git add be-esimedia/src/main/java/edu/uclm/esi/esimedia/be_esimedia/config/WebConfig.java
git add be-esimedia/src/main/resources/application.properties

Write-ColorOutput "✅ Archivos añadidos`n" "Green"

# 5. Mostrar resumen
Write-ColorOutput "📊 Resumen de cambios:" "Cyan"
git status -s
Write-ColorOutput ""

# 6. Confirmar commit
$response = Read-Host "¿Quieres hacer commit de estos cambios? (S/N)"
if ($response -ne 'S' -and $response -ne 's') {
    Write-ColorOutput "❌ Operación cancelada" "Red"
    exit 0
}

# 7. Hacer commit
Write-ColorOutput "`n💾 Haciendo commit..." "Yellow"
git commit -m $CommitMessage
Write-ColorOutput "✅ Commit realizado`n" "Green"

# 8. Confirmar push
Write-ColorOutput "📤 ¿Quieres hacer push al repositorio remoto?" "Cyan"
Write-ColorOutput "   Esto iniciará el despliegue automático en Render si ya está configurado." "Gray"
$pushResponse = Read-Host "(S/N)"

if ($pushResponse -eq 'S' -or $pushResponse -eq 's') {
    Write-ColorOutput "`n🚀 Haciendo push..." "Yellow"
    
    # Verificar rama actual
    $currentBranch = git branch --show-current
    Write-ColorOutput "   Rama: $currentBranch" "Gray"
    
    git push origin $currentBranch
    
    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput "✅ Push realizado exitosamente!`n" "Green"
        Write-ColorOutput "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "Cyan"
        Write-ColorOutput "✨ Repositorio preparado para Render!" "Green"
        Write-ColorOutput "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" "Cyan"
        
        Write-ColorOutput "📚 Próximos pasos:" "Yellow"
        Write-ColorOutput "   1. Ve a https://dashboard.render.com" "White"
        Write-ColorOutput "   2. Click en 'New +' → 'Web Service'" "White"
        Write-ColorOutput "   3. Conecta tu repositorio: JavierPs287/prueba-render" "White"
        Write-ColorOutput "   4. Configura las variables de entorno" "White"
        Write-ColorOutput "   5. ¡Despliega!" "White"
        Write-ColorOutput "`n   📖 Lee RENDER_DEPLOYMENT.md para más detalles`n" "Gray"
    } else {
        Write-ColorOutput "❌ Error al hacer push. Verifica tu conexión y permisos." "Red"
        exit 1
    }
} else {
    Write-ColorOutput "`n✅ Cambios commiteados localmente" "Green"
    Write-ColorOutput "   Para hacer push después, ejecuta: git push origin main`n" "Gray"
}

Write-ColorOutput "🎉 ¡Proceso completado!`n" "Green"
