# Script simple de validacion para Azure DevOps Pipeline
# Verifica que los archivos necesarios existan

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Validacion de Pipeline - ESI-MEDIA" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$allGood = $true

# Archivos a verificar
$files = @{
    "azure-pipelines.yml" = "Pipeline de Azure DevOps"
    "Dockerfile" = "Configuracion Docker"
    "docker-compose.yml" = "Docker Compose"
    "render.yaml" = "Configuracion Render"
    "be-esimedia\pom.xml" = "Backend POM"
    "fe-esimedia\package.json" = "Frontend package.json"
}

Write-Host "Verificando archivos necesarios..." -ForegroundColor Yellow
Write-Host ""

foreach ($file in $files.GetEnumerator()) {
    if (Test-Path $file.Key) {
        Write-Host "[OK]   $($file.Value)" -ForegroundColor Green
    } else {
        Write-Host "[FALTA] $($file.Value): $($file.Key)" -ForegroundColor Red
        $allGood = $false
    }
}

Write-Host ""

# Verificar Git
Write-Host "Verificando Git..." -ForegroundColor Yellow
try {
    $gitBranch = git branch --show-current 2>&1
    Write-Host "[OK]   Rama actual: $gitBranch" -ForegroundColor Green
    
    $gitStatus = git status --porcelain 2>&1
    if ($gitStatus) {
        Write-Host "[INFO] Hay cambios sin commitear" -ForegroundColor Yellow
    }
} catch {
    Write-Host "[WARN] Git no configurado" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan

# Resumen
if ($allGood) {
    Write-Host ""
    Write-Host "TODO LISTO!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Proximos pasos:" -ForegroundColor White
    Write-Host "1. git add ." -ForegroundColor Gray
    Write-Host "2. git commit -m 'chore: Add Azure DevOps pipeline'" -ForegroundColor Gray
    Write-Host "3. git push origin main" -ForegroundColor Gray
    Write-Host "4. Configurar pipeline en https://dev.azure.com" -ForegroundColor Gray
    Write-Host ""
    exit 0
} else {
    Write-Host ""
    Write-Host "Faltan archivos necesarios!" -ForegroundColor Red
    Write-Host "Revisa los errores arriba." -ForegroundColor Red
    Write-Host ""
    exit 1
}
