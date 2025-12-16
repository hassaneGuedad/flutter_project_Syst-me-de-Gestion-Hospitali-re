@echo off
echo ========================================
echo  Hospital Management System
echo  Lancement Complet (Backend + Frontend)
echo ========================================
echo.

REM Vérifier si Flutter est installé
where flutter >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERREUR] Flutter n'est pas installe.
    echo Veuillez installer Flutter depuis: https://flutter.dev/docs/get-started/install/windows
    echo.
    pause
    exit /b 1
)

REM Vérifier si Maven est installé (pour le backend)
where mvn >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ATTENTION] Maven n'est pas installe. Le backend ne pourra pas etre lance.
    echo.
)

echo [1/5] Demarrage du backend...
echo.
start "Backend - Hospital API" cmd /k "cd backend && mvn spring-boot:run"
timeout /t 5 /nobreak >nul
echo Backend en cours de demarrage...
echo.

echo [2/5] Installation des dependances Flutter...
flutter pub get
if %ERRORLEVEL% NEQ 0 (
    echo [ERREUR] Echec de l'installation des dependances Flutter.
    pause
    exit /b 1
)
echo.

echo [3/5] Generation du code Flutter...
dart run build_runner build --delete-conflicting-outputs
if %ERRORLEVEL% NEQ 0 (
    echo [ATTENTION] La generation du code a echoue, mais on continue...
)
echo.

echo [4/5] Attente du backend (15 secondes)...
timeout /t 15 /nobreak >nul
echo.

echo [5/5] Lancement de l'application Flutter...
echo.
echo Selectionnez votre plateforme:
echo   1. Chrome (Web) - Recommande
echo   2. Windows (Desktop)
echo   3. Android
echo.
set /p choice="Votre choix (1-3): "

if "%choice%"=="1" (
    echo Lancement sur Chrome...
    start "Flutter App - Chrome" cmd /k "flutter run -d chrome"
) else if "%choice%"=="2" (
    echo Lancement sur Windows...
    start "Flutter App - Windows" cmd /k "flutter run -d windows"
) else if "%choice%"=="3" (
    echo Lancement sur Android...
    start "Flutter App - Android" cmd /k "flutter run"
) else (
    echo Choix invalide. Lancement par defaut sur Chrome...
    start "Flutter App" cmd /k "flutter run -d chrome"
)

echo.
echo ========================================
echo  Projet lance !
echo.
echo  Backend API: http://localhost:8080
echo  Frontend: En cours de demarrage...
echo ========================================
echo.
echo Appuyez sur une touche pour fermer cette fenetre...
echo (Les fenetres du backend et du frontend resteront ouvertes)
pause >nul

