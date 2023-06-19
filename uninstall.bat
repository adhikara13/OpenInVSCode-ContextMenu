@echo off
setlocal
set "ScriptPath=%~dp0open_in_vscode.ps1"
powershell.exe -ExecutionPolicy Bypass -File "%ScriptPath%" -Uninstall
pause
