@echo off
:: Check if the script is running with administrator privileges
>nul 2>&1 net session || (
    echo This script requires administrator privileges. Please run it as an administrator.
    pause
    exit /b 1
)

setlocal enabledelayedexpansion

:: Define la ruta relativa para los archivos de texto
set "script_dir=%~dp0"
set "hosts_file=%windir%\System32\drivers\etc\hosts"
set "backup_file=%script_dir%hosts_backup.txt"
set "soft_file=%script_dir%HS_Soft.txt"
set "medium_file=%script_dir%HS_Medium.txt"
set "hard_file=%script_dir%HS_Hard.txt"
set "start_time=!time!"

:menu
cls
echo Hosts File Updater Menu:
echo 1. Soft Update
echo 2. Medium Update
echo 3. Hard Update
echo 4. Revert to Backup
echo 5. Exit

set /p option="Select Option: "

if "%option%"=="1" (
    set "update_file=!soft_file!"
    call :UpdateHosts
) else if "%option%"=="2" (
    set "update_file=!medium_file!"
    call :UpdateHosts
) else if "%option%"=="3" (
    set "update_file=!hard_file!"
    call :UpdateHosts
) else if "%option%"=="4" (
    call :RevertToBackup
) else if "%option%"=="5" (
    goto :end
) else (
    echo Invalid option. Please enter a valid number.
    pause
    goto menu
)

goto :menu

:UpdateHosts
rem Backup the current hosts file
copy /y "!hosts_file!" "!backup_file!"

echo Updating hosts file...

copy /b "!hosts_file!"+"!update_file!" "!hosts_file!"

echo Lines added to the hosts file.

set "end_time=!time!"
call :CalculateElapsedTime

goto :eof

:RevertToBackup
if exist "!backup_file!" (
    echo Reverting to the backup...
    copy /y "!backup_file!" "!hosts_file!"
    echo Hosts file reverted to the backup.
) else (
    echo No backup file found.
)

pause
goto :eof

:CalculateElapsedTime
rem Calculate elapsed time
for /f "tokens=1-4 delims=:." %%a in ("!start_time!") do (
    set /a "hours_start=%%a", "minutes_start=%%b", "seconds_start=%%c", "milliseconds_start=%%d"
)
for /f "tokens=1-4 delims=:." %%a in ("!end_time!") do (
    set /a "hours_end=%%a", "minutes_end=%%b", "seconds_end=%%c", "milliseconds_end=%%d"
)

set /a "elapsed_hours=hours_end-hours_start"
set /a "elapsed_minutes=minutes_end-minutes_start"
set /a "elapsed_seconds=seconds_end-seconds_start"
set /a "elapsed_milliseconds=milliseconds_end-milliseconds_start"

rem Ensure differences are positive numbers
if !elapsed_milliseconds! lss 0 (
    set /a "elapsed_seconds-=1"
    set /a "elapsed_milliseconds+=1000"
)
if !elapsed_seconds! lss 0 (
    set /a "elapsed_minutes-=1"
    set /a "elapsed_seconds+=60"
)
if !elapsed_minutes! lss 0 (
    set /a "elapsed_hours-=1"
    set /a "elapsed_minutes+=60"
)

echo Elapsed Time: !elapsed_hours!:!elapsed_minutes!:!elapsed_seconds!.!elapsed_milliseconds!
pause
goto :eof

:end
