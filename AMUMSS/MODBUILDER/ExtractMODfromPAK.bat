@echo off
REM echo.^>^>^>      In ExtractMODfromPAK.bat

rem All defined variables in ExtractMODfromPAK.bat start with _e (except FOR loop first parameter)
rem so we can easily list them all like this on error, if needed: set _e

SETLOCAL EnableDelayedExpansion ENABLEEXTENSIONS

set "_eE=E:"
if defined _mVERBOSE set "_eE=ExtractMODfromPAK.bat:"

REM echo.^>^>^> ExtractMODfromPAK: Starting directory
REM echo.%CD%

rd /S /Q "%CD%\_TEMP2" 1>NUL 2>NUL

REM echo.
if not exist "%CD%\_TEMP2" (
	mkdir "%CD%\_TEMP2\"
	xcopy /y /h /v "..\MODBUILDER\psarc.exe" "%CD%\_TEMP2\" 1>NUL 2>NUL
)

xcopy /y /h /v "%_bPaknamePATH%" "%CD%\_TEMP2\" 1>NUL 2>NUL

REM echo.
REM echo.^>^>^> ExtractMODfromPAK: Changing to directory _TEMP2
cd _TEMP2
REM echo.^>^>^> Changed to %CD%

echo.
echo.%_zGREEN%^>^>^> %_bB% Unpacking pak...%_zDEFAULT%
echo|set /p="[INFO]:   Unpacking pak...">>"..\..\REPORT.txt" & echo.>>"..\..\REPORT.txt"

FOR /r %%H in (*.pak) do (
	psarc.exe extract "%%H" --to="..\EXTRACTED_PAK" -y
)

REM echo.
REM echo.^>^>^> Extracted %_bNumberFiles% PAK file(s)
cd ..

rem doing it in two step so we can use the pak info in ModScript with a .lua
rem when one exist (inside the pak or from the user)
xcopy /y /h /v /e "EXTRACTED_PAK\*.*" "..\UNPACKED_DECOMPILED_PAKs\%_bPAKname%\EXTRACTED_PAK\" 1>NUL 2>NUL
 
REM echo.
REM echo.^>^>^> %_eE% Removing folder _TEMP2
Del /f /q /s "_TEMP2\*.*" 1>NUL 2>NUL
:RETRY
if exist "_TEMP2" (
	rd /s /q "_TEMP2" 2>NUL
	goto :RETRY
)


