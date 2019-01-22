@echo off
setlocal EnableDelayedExpansion
rem set then environment variables in bld.env
for /F %%a in (bld.env) do set %%a

rem the 'src' directory is mapped to c:\'src' directory in the container, 
rem same for the results directory
set "SHARE_SRC_ARG=-v %CD%:c:\%SRC%"
set "SHARE_RES_ARG=-v %CD%\results:c:\results -e RESULTS_DIR=c:\results"
rem does the base image exist?
docker inspect --format='{{.Config.Image}}' %IMAGE% >nul 2>&1
if errorlevel 1 (
	echo ERROR: Aborting, the base %IMAGE% is not present
	goto theend)

@if not exist results mkdir results

echo Creating docker container using %IMAGE%
echo  Directory %SRC% is shared to the container
echo  Directory results contains the results
docker run --rm %SHARE_SRC_ARG% %SHARE_RES_ARG% --workdir c:\src %IMAGE% cmd.exe /c bld_and_mfurun.bat

echo.
echo Test results can be found in results dir:
dir results
:theend
