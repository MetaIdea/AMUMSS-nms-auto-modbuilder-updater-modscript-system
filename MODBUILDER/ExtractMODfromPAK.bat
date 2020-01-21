@echo off
REM echo.^>^>^>      In ExtractMODfromPAK.bat

rem All defined variables in ExtractMODfromPAK.bat start with _e (except FOR loop first parameter)
rem so we can easily list them all like this on error, if needed: set _e

set "_eE=E:"
if defined _mVERBOSE set "_eE=ExtractMODfromPAK.bat:"

REM echo.^>^>^> ExtractMODfromPAK: Starting directory
REM echo.%CD%

REM echo.
if not exist "%CD%\_TEMP2" (
	mkdir "%CD%\_TEMP2\"
	xcopy /y /h /v "..\MODBUILDER\psarc.exe" "%CD%\_TEMP2\" 1>NUL 2>NUL
) else (
	REM echo.^>^>^> XXXXX Directory _TEMP2 already exist, it should have been REMOVED XXXXX
)

REM echo.
REM echo.^>^>^> ExtractMODfromPAK: Changing to directory _TEMP2
cd _TEMP2
REM echo.^>^>^> Changed to %CD%

echo.
echo.^>^>^> %_eE% Extracting files from User PAK file
FOR /r %%G in (..\*.pak) do psarc.exe extract "%%G" --to="..\EXTRACTED_PAK" -y

cd ..

REM echo.
REM echo.^>^>^> %_eE% Removing folder _TEMP2
Del /f /q /s "_TEMP2\*.*" 1>NUL 2>NUL
:RETRY
if exist "_TEMP2" (
	rd /s /q "_TEMP2" 2>NUL
	goto :RETRY
)


