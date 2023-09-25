@echo off

set "script_dir=%~dp0"

:menu
cls
echo Main Menu:
echo 1. IP Blocker Firewall
echo 2. Hosts File Blocker
echo 3. Exit

set /p option="Select an option: "

if "%option%"=="1" (
    :: Cambia al directorio del script del firewall y ejecútalo
    cd /d "%script_dir%"
    call firewall.bat
) else if "%option%"=="2" (
    :: Cambia al directorio del script de hosts y ejecútalo
    cd /d "%script_dir%"
    call hosts.bat
) else if "%option%"=="3" (
    exit
) else (
    echo Invalid option. Please enter a valid number.
    pause
    goto menu
)

exit /b
