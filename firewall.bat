@echo off
setlocal enabledelayedexpansion

:: Guarda el directorio actual
set "current_dir=%~dp0"

:: Define las rutas relativas de los archivos de texto
set "hardcore=FW_Hard.txt"
set "soft=FW_Soft.txt"
set "medium=FW_Medium.txt"
set "inicio=!time!"

cls
echo Firewall IP Blocker:
echo 1. Soft.
echo 2. Medium.
echo 3. Hardcore Warning!! +200.000 IP Blocked.
echo 4. Back to menu.

set /p opcion="Select Option: "

if "%opcion%"=="1" (
    call :BlockIPs %soft%
) else if "%opcion%"=="2" (
    call :BlockIPs %medium%
) else if "%opcion%"=="3" (
    call :BlockIPs %hardcore%
) else if "%opcion%"=="4" (
    call menu.bat
) else (
    echo Invalid option. Please enter a valid number.
    pause
    goto menu.bat
)

goto :eof

:BlockIPs
:: Construye la ruta completa del archivo de texto usando la ruta relativa
set "file=%current_dir%\%1"
for /f %%i in (!file!) do (
    netsh advfirewall firewall add rule name="Windows IP Blocker - In: %%i" dir=in action=block remoteip=%%i
    netsh advfirewall firewall add rule name="Windows IP Blocker - Out: %%i" dir=out action=block remoteip=%%i
    echo IP: %%i Blocked in Windows Firewall.
)

set "fin=!time!"
for /f "tokens=1-4 delims=:." %%a in ("%inicio%") do (
    set /a "horas_inicio=%%a", "minutos_inicio=%%b", "segundos_inicio=%%c", "milisegundos_inicio=%%d"
)
for /f "tokens=1-4 delims=:." %%a in ("%fin%") do (
    set /a "horas_fin=%%a", "minutos_fin=%%b", "segundos_fin=%%c", "milisegundos_fin=%%d"
)

set /a "diferencia_horas=horas_fin-horas_inicio"
set /a "diferencia_minutos=minutos_fin-minutos_inicio"
set /a "diferencia_segundos=segundos_fin-segundos_inicio"
set /a "diferencia_milisegundos=milisegundos_fin-milisegundos_inicio"

rem Ensure differences are positive numbers
if !diferencia_milisegundos! lss 0 (
    set /a "diferencia_segundos-=1"
    set /a "diferencia_milisegundos+=1000"
)
if !diferencia_segundos! lss 0 (
    set /a "diferencia_minutos-=1"
    set /a "diferencia_segundos+=60"
)
if !diferencia_minutos! lss 0 (
    set /a "diferencia_horas-=1"
    set /a "diferencia_minutos+=60"
)

echo Execution time: !diferencia_horas!:!diferencia_minutos!:!diferencia_segundos!.!diferencia_milisegundos!
pause
goto :eof
