@echo off
powershell -noprofile -ex unrestricted "& '%~dp0\sambs-installer-uninstall.ps1';exit $lastexitcode"
