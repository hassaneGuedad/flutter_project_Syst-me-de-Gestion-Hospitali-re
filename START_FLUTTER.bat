@echo off
echo ========================================
echo  Hospital Flutter App - Quick Start
echo ========================================
echo.

REM Vérifier si Flutter est installé
where flutter >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERREUR] Flutter n'est pas installe ou n'est pas dans le PATH.
    echo.
    echo Veuillez installer Flutter depuis: https://flutter.dev/docs/get-started/install/windows
    echo.
    echo Apres l'installation, ajoutez Flutter au PATH ou redemarrez votre terminal.
    echo.
    pause
    exit /b 1
)

echo [1/4] Verification de Flutter...
flutter --version
echo.

echo [2/4] Installation des dependances...
flutter pub get
if %ERRORLEVEL% NEQ 0 (
    echo [ERREUR] Echec de l'installation des dependances.
    pause
    exit /b 1
)
echo.

echo [3/4] Generation du code...
dart run build_runner build --delete-conflicting-outputs
if %ERRORLEVEL% NEQ 0 (
    echo [ATTENTION] La generation du code a echoue, mais on continue...
)
echo.

echo [4/4] Lancement de l'application...
echo.
echo Selectionnez votre plateforme:
echo   1. Chrome (Web)
echo   2. Windows (Desktop)
echo   3. Android (si un appareil/emulateur est connecte)
echo   4. Liste des appareils disponibles
echo.
set /p choice="Votre choix (1-4): "

if "%choice%"=="1" (
    echo Lancement sur Chrome...
    flutter run -d chrome
) else if "%choice%"=="2" (
    echo Lancement sur Windows...
    flutter run -d windows
) else if "%choice%"=="3" (
    echo Lancement sur Android...
    flutter run
) else if "%choice%"=="4" (
    echo Appareils disponibles:
    flutter devices
    echo.
    pause
    goto :end
) else (
    echo Choix invalide. Lancement par defaut...
    flutter run
)

:end
pause

