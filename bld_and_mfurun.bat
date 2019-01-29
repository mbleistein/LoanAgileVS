@echo off
setlocal
set WORK_DIR=c:\work
echo.
echo Compiling:
msbuild LoanAgileVS.sln /p:OutDir=%WORK_DIR% /p:BaseIntermediateOutputPath=%WORK_DIR%\obj\ /verbosity:minimal /p:Configuration=Release
if errorlevel 1 goto theend

cd %WORK_DIR%
dir
echo Running tests:
mfurun  -jenkins-ci -timeout:10s -sp -outdir:results TestLoanAgileVS.mfu
echo.
echo Moving test results out of the container.
move results\*.* %RESULTS_DIR% >nul
if errorlevel 1 echo WARNING: move results failed

:theend