@echo off
setlocal
if not ".%*" == "." goto got_cline
echo cmd64: No command given
goto theend
:got_cline
if not .%VCROOT% == . goto got_vcroot
reg query "HKLM\SOFTWARE\Micro Focus\Visual COBOL" /v "DefaultVersion" | findstr "DefaultVersion" >reg.tmp
FOR /F "tokens=3*" %%a IN (reg.tmp) DO SET "VCVERSION=%%a"
reg query "HKLM\SOFTWARE\Micro Focus\Visual COBOL\%VCVERSION%" /v "INSTALLDIR" | findstr "INSTALLDIR" >reg.tmp
FOR /F "tokens=3*" %%a IN (reg.tmp) DO SET "VCROOT=%%a"
del reg.tmp

:got_vcroot

set CMD32HOME=%CD%
if .%PROCESSOR_ARCHITECTURE% == .AMD64 goto already64
echo Using 64 cmd.exe
%windir%\sysnative\cmd.exe /c "%VCROOT%\createenv.bat 64 && CD /D %CMD32HOME% && %*"
goto theend
:already64
call %VCROOT%\createenv.bat 64
cd /D %CMD32HOME%
%*
:theend