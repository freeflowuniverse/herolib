@echo off
REM Script to install the OurDB Viewer extension to VSCode on Windows

REM Set extension directory
set EXTENSION_DIR=%USERPROFILE%\.vscode\extensions\local-herolib.ourdb-viewer-0.0.1

REM Create extension directory
if not exist "%EXTENSION_DIR%" mkdir "%EXTENSION_DIR%"

REM Copy extension files
copy /Y "%~dp0extension.js" "%EXTENSION_DIR%\"
copy /Y "%~dp0package.json" "%EXTENSION_DIR%\"
copy /Y "%~dp0README.md" "%EXTENSION_DIR%\"

echo OurDB Viewer extension installed to: %EXTENSION_DIR%
echo Please restart VSCode for the changes to take effect.
echo After restarting, you should be able to open .ourdb files.

pause
