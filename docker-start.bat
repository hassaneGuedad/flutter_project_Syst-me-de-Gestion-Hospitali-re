@echo off
echo ========================================
echo  Hospital Management System
echo  Lancement avec Docker
echo ========================================
echo.

REM Vérifier si Docker est installé
where docker >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERREUR] Docker n'est pas installe ou n'est pas dans le PATH.
    echo.
    echo Veuillez installer Docker Desktop depuis: https://www.docker.com/products/docker-desktop
    echo.
    pause
    exit /b 1
)

REM Vérifier si Docker Compose est disponible
docker compose version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERREUR] Docker Compose n'est pas disponible.
    pause
    exit /b 1
)

echo [1/4] Arret des containers existants...
docker compose down
echo.

echo [2/4] Construction des images Docker...
docker compose build
if %ERRORLEVEL% NEQ 0 (
    echo [ERREUR] Echec de la construction des images.
    pause
    exit /b 1
)
echo.

echo [3/4] Demarrage des services...
docker compose up -d
if %ERRORLEVEL% NEQ 0 (
    echo [ERREUR] Echec du demarrage des services.
    pause
    exit /b 1
)
echo.

echo [4/4] Attente du demarrage complet (30 secondes)...
timeout /t 30 /nobreak >nul
echo.

echo ========================================
echo  Projet lance avec Docker !
echo ========================================
echo.
echo  Frontend: http://localhost:3000
echo  Backend API: http://localhost:8080
echo  PostgreSQL: localhost:5432
echo.
echo  Pour voir les logs:
echo    docker compose logs -f
echo.
echo  Pour arreter:
echo    docker compose down
echo ========================================
echo.

REM Afficher les logs
echo Affichage des logs (Ctrl+C pour quitter)...
docker compose logs -f

