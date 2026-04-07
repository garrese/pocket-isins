<#
.SYNOPSIS
Descarga todas las referencias de origin y crea/trackea una rama local por cada rama remota.

.DESCRIPTION
Al ejecutar este script, se asegura de que cualquier rama remota que no tengamos 
creada localmente pase a existir en nuestro entorno. 
Esto es esencial para que "git filter-branch --all" recalcule también esas ramas.
#>

Write-Host "Descargando información más reciente del repositorio (git fetch --all)..."
git fetch --all

Write-Host "Buscando ramas remotas en 'origin'..."
# Obtener ramas remotas, filtrando las que son de origin y descartando "HEAD -> origin/master" etc.
$remoteBranches = git branch -r | Where-Object { $_ -match "origin/" -and $_ -notmatch "->" }

foreach ($branchLine in $remoteBranches) {
    # Limpiamos los espacios en blanco
    $remoteBranch = $branchLine.Trim()
    
    # Extraemos el nombre local (quitando "origin/")
    $localBranch = $remoteBranch -replace "^origin/", ""

    # Verificamos si la rama ya existe en local
    $localExists = git branch --list $localBranch
    
    if (-not $localExists) {
        Write-Host "Creando y trackeando rama local: $localBranch -> $remoteBranch"
        # Usamos invoke-expression porque redirigir la salida estándar de error de un exe en PS puede ser peculiar
        git branch --track $localBranch $remoteBranch 2>$null
    } else {
        Write-Host "La rama local '$localBranch' ya existe. Saltando."
    }
}

Write-Host ""
Write-Host "¡Todas las ramas remotas han sido importadas al entorno local con éxito!"
