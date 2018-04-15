@echo off
setlocal
if not ".%*" == "." goto got_cline
echo cmd32: No command given
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
if .%PROCESSOR_ARCHITECTURE% == .x86 goto already32
echo Using 32bit cmd.exe
%windir%\syswow64\cmd.exe /c /k "%VCROOT%\createenv.bat && cd /D %CMD32HOME% && %*"
goto theend
:already32
call %VCROOT%\createenv.bat
cd /D %CMD32HOME%
%*
:theend