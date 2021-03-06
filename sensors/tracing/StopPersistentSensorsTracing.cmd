@ECHO OFF

SETLOCAL ENABLEDELAYEDEXPANSION

CALL WHOAMI.EXE /GROUPS | FIND.EXE /I "S-1-16-12288" >nul
IF ERRORLEVEL 1 (
    ECHO This script must be run from an elevated prompt.
    ECHO Script will exit now....
    EXIT /B 1
)

echo Stopping trace...
logman stop -n SensorsTrace -ets >nul
logman delete -n autosession\SensorsTrace >nul
echo Now collecting version info
reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion" /v BuildLabEX >> %SystemRoot%\Tracing\BuildNumber.txt
powershell "(dir %SYSTEMROOT%\system32\drivers\UMDF\SensorsHid.dll).VersionInfo | fl" >> %SystemRoot%\Tracing\BuildNumber.txt
dir /s %SystemRoot%\LiveKernelReports\* >> %SystemRoot%\Tracing\BuildNumber.txt
start %SystemRoot%\Tracing