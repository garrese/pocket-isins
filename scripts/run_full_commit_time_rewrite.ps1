<#
.SYNOPSIS
Automatiza completamente el flujo de reescritura de timestamps en el historial de Git a las 00:00.

.DESCRIPTION
Este script ejecuta secuencialmente:
1. La descarga y tracking de todas las ramas remotas.
2. La ejecución de git filter-branch para cambiar la hora de todos los commits de todas las ramas.
3. (Opcional interactivo) Un push force para sobreescribir el origen con la nueva historia paralela con los hashes recién calculados.
#>

$ErrorActionPreference = "Stop"

Write-Host "===========================================================" -ForegroundColor Cyan
Write-Host "Paso 1: Preparar Ramas (Fetch & Track)" -ForegroundColor Cyan
Write-Host "===========================================================" -ForegroundColor Cyan
try {
    .\scripts\fetch_all_branches.ps1
} catch {
    Write-Host "Hubo un error al descargar/trackear las ramas." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "===========================================================" -ForegroundColor Cyan
Write-Host "Paso 2: Reescribir el historial de commits a las 00:00:00" -ForegroundColor Cyan
Write-Host "===========================================================" -ForegroundColor Cyan
try {
    .\scripts\rewrite_commit_times.ps1
} catch {
    Write-Host "Hubo un error critico durante filter-branch." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "===========================================================" -ForegroundColor Cyan
Write-Host "Paso 3: Subida forzada (Push Force) al servidor (origin)" -ForegroundColor Cyan
Write-Host "===========================================================" -ForegroundColor Cyan
Write-Host "ATENCION: Se va a aplastar la historia del repositorio remoto." -ForegroundColor Yellow
Write-Host "Si continuas, tus ramas web seran reemplazadas por las nuevas forzadas." -ForegroundColor Yellow

$response = Read-Host "Deseas ejecutar git push --all --force y git push --tags --force ahora? (S/N)"
if ($response -match "^[sS]") {
    Write-Host "Ejecutando Push de ramas..."
    git push --all --force
    Write-Host "Ejecutando Push de etiquetas (tags)..."
    git push --tags --force
    Write-Host "Subida completada!" -ForegroundColor Green
} else {
    Write-Host "Has cancelado la subida forzada. Los cambios solo estan en tu equipo local." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "==== PROCESO COMPLETADO ====" -ForegroundColor Green
Write-Host "Tus copias de seguridad de los commits originales se mantienen a salvo en la carpeta oculta de Git (.git/refs/original/)."
