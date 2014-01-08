@echo off

REM get current path of batch file scripts
for /f %%i in ("%0") do set curpath=%%~dpi
call %curpath%ci-helper-base.bat %1 %2

if "%1"=="install" (
  move %WORK_DIR%/railo-express* %WORK_DIR%/railo
  move %WORK_DIR%/mxunit* %WORK_DIR%/railo/webapps/www/mxunit
) else (
  echo "Usage: %MY_DIR% install"
)