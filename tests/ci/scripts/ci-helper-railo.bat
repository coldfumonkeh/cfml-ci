@echo on

REM get current path of batch file scripts
for /f %%i in ("%0") do set curpath=%%~dpi
call %curpath%ci-helper-base.bat %1 %2

if "%1"=="install" (
  move %WORK_DIR%\railo-express* %WORK_DIR%\railo
  move %WORK_DIR%\mxunit* %WORK_DIR%\railo\webapps\www\mxunit
  echo copying %SCRIPT_DIR%\tests\ %WORK_DIR%\railo\webapps\www\%TEST_PROJECT%\tests\
  mkdir %WORK_DIR%\railo\webapps\www\%TEST_PROJECT%\tests\
  xcopy %SCRIPT_DIR%\tests\*.* %WORK_DIR%\railo\webapps\www\%TEST_PROJECT%\tests\ /s /e
) else if "%1"=="start" (
  echo changing dir to %WORK_DIR%\railo
  cd %WORK_DIR%\railo
  echo starting server
  cmd /k start.bat
) else if "%1"=="stop" (
  echo changing dir to %WORK_DIR%\railo
  cd %WORK_DIR%\railo
  echo stopping server
  cmd /k stop.bat
) else (
  echo "Usage: %MY_DIR% (install|start|stop)"
)