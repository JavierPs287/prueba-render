# Script de PowerShell para gestionar la aplicación ESI-MEDIA dockerizada
# Uso: .\run-docker.ps1 [comando]
# Comandos: build, start, stop, restart, logs, clean

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet('build', 'start', 'stop', 'restart', 'logs', 'clean', 'status')]
    [string]$Command = 'start'
)

$ErrorActionPreference = "Stop"

function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

function Show-Help {
    Write-ColorOutput "`n🐳 ESI-MEDIA Docker Manager" "Cyan"
    Write-ColorOutput "============================`n" "Cyan"
    Write-ColorOutput "Comandos disponibles:" "Yellow"
    Write-ColorOutput "  build   - Construir la imagen Docker" "White"
    Write-ColorOutput "  start   - Iniciar la aplicación (construye si es necesario)" "White"
    Write-ColorOutput "  stop    - Detener la aplicación" "White"
    Write-ColorOutput "  restart - Reiniciar la aplicación" "White"
    Write-ColorOutput "  logs    - Ver los logs de la aplicación" "White"
    Write-ColorOutput "  status  - Ver el estado de los contenedores" "White"
    Write-ColorOutput "  clean   - Limpiar contenedores e imágenes" "White"
    Write-ColorOutput "`nEjemplo: .\run-docker.ps1 start`n" "Gray"
}

function Test-DockerInstalled {
    try {
        docker --version | Out-Null
        return $true
    } catch {
        Write-ColorOutput "❌ Docker no está instalado o no está en el PATH" "Red"
        Write-ColorOutput "Descárgalo desde: https://www.docker.com/products/docker-desktop" "Yellow"
        return $false
    }
}

function Build-Application {
    Write-ColorOutput "`n🔨 Construyendo la aplicación..." "Cyan"
    docker-compose build
    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput "✅ Construcción completada exitosamente!`n" "Green"
    } else {
        Write-ColorOutput "❌ Error en la construcción`n" "Red"
        exit 1
    }
}

function Start-Application {
    Write-ColorOutput "`n🚀 Iniciando la aplicación ESI-MEDIA..." "Cyan"
    docker-compose up -d
    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput "✅ Aplicación iniciada exitosamente!" "Green"
        Write-ColorOutput "🌐 Accede a: http://localhost:8081" "Yellow"
        Write-ColorOutput "📝 Ver logs: .\run-docker.ps1 logs`n" "Gray"
    } else {
        Write-ColorOutput "❌ Error al iniciar la aplicación`n" "Red"
        exit 1
    }
}

function Stop-Application {
    Write-ColorOutput "`n🛑 Deteniendo la aplicación..." "Cyan"
    docker-compose down
    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput "✅ Aplicación detenida exitosamente!`n" "Green"
    } else {
        Write-ColorOutput "❌ Error al detener la aplicación`n" "Red"
        exit 1
    }
}

function Restart-Application {
    Write-ColorOutput "`n🔄 Reiniciando la aplicación..." "Cyan"
    Stop-Application
    Start-Application
}

function Show-Logs {
    Write-ColorOutput "`n📋 Mostrando logs (Ctrl+C para salir)...`n" "Cyan"
    docker-compose logs -f
}

function Show-Status {
    Write-ColorOutput "`n📊 Estado de los contenedores:`n" "Cyan"
    docker-compose ps
    Write-ColorOutput "`n"
}

function Clean-Application {
    Write-ColorOutput "`n🧹 Limpiando contenedores e imágenes..." "Yellow"
    $response = Read-Host "¿Estás seguro? Esto eliminará el contenedor y la imagen (S/N)"
    if ($response -eq 'S' -or $response -eq 's') {
        docker-compose down
        docker rmi esimedia-app:latest -f 2>$null
        Write-ColorOutput "✅ Limpieza completada!`n" "Green"
    } else {
        Write-ColorOutput "❌ Operación cancelada`n" "Red"
    }
}

# Main Script
Clear-Host

if (-not (Test-DockerInstalled)) {
    exit 1
}

switch ($Command) {
    'build' { Build-Application }
    'start' { Start-Application }
    'stop' { Stop-Application }
    'restart' { Restart-Application }
    'logs' { Show-Logs }
    'status' { Show-Status }
    'clean' { Clean-Application }
    default { Show-Help }
}
