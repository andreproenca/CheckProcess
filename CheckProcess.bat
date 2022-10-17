@echo off
REM Script to monitoring and kill application services on Task Manager

setlocal enableextensions
REM Put the service name bellow Eg.: winword.exe, excel.exe
set process= Servicename.exe
set count=0
set logdate=%date:~6,4%-%date:~3,2%-%date:~0,2%
set loghour=%time:~0,2%:%time:~3,2%
rem put the local and log name.
set LOGFILE=c:\temp\check_process_%logdate%.log

REM First of all it's verifyied if there's a process running, if not go to minor, if there's go to exist
tasklist | findstr /I "%process%"
if %errorlevel% == 1 goto minor
if %errorlevel% == 0 goto exist


:exist
for /f %%x in ('TASKLIST /FI "IMAGENAME eq %process%" /NH') do set /a count+=1

rem if count is minor or equal than 2, go to minor block *** you can change the number of processes you want to check
rem if count is major than 2, go to major block to kill all processes
if %count% LEQ 2 ( 
goto minor
) 
else (
rem if %count% GTR 2 goto major
goto major
)
    
:major
echo %logdate% - %loghour% Had %count% process %process% opened - Process Finished! >> %LOGFILE%
TASKKILL /IM %process%  /F /T 
goto final

:minor
echo %logdate% - %loghour% Has no process %process% opened >> %LOGFILE%
goto final

:final
endlocal

