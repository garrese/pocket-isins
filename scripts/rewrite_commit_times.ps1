<#
.SYNOPSIS
Reescribe el historial del repositorio con la hora fijada a las 19:00.

.DESCRIPTION
Este script iterará sobre todos los commits referenciando a un script sh
para cambiar la marca de tiempo a las 19:00:00. Usa git filter-branch.
#>

Write-Host "Iniciando reescritura de GIT_AUTHOR_DATE y GIT_COMMITTER_DATE a las 19:00..."

# Resolvemos la ruta absoluta al script para que sh lo encuentre desde cualquier subdirectorio
$scriptPath = (Resolve-Path "scripts\filter.sh").Path -replace '\\', '/'

# Ejecutamos filter-branch suministrando la carga útil en un archivo para evitar errores de comillas
git filter-branch -f --env-filter ". `"$scriptPath`"" -- --all

Write-Host ""
Write-Host "¡Completado!"
