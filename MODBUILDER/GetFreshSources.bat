@echo off
echo.^>^>^>     In GetFreshSources.bat
rem All defined variables in GetFreshSources.bat start with _g (except FOR loop first parameter)
rem so we can easily list them all like this on error, if needed: set _g

set "_gG=G:"
if defined _mVERBOSE set "_gG=GetFreshSources.bat:"

set /p _gNMS_FOLDER=<NMS_FOLDER.txt
set _gNMS_PCBANKS_FOLDER=%_gNMS_FOLDER%\GAMEDATA\PCBANKS\

if defined _mVERBOSE (
	echo.^>^>^> %_gG% Starting directory
	echo.%CD%
)	

rem FOR PSEUDO CODE, see GetFreshSources_LOGIC.txt

rem *************************   WE ARE IN MODBUILDER   ************************

if not exist "%CD%\_TEMP" (
	echo.
	echo.^>^>^> %_gG% Creating _TEMP folder
	mkdir "%CD%\_TEMP\"
) else (
	if defined _mVERBOSE (
		echo.
		echo.^>^>^> %_gG% Folder _TEMP already exist
	)
)

rem ********************************  WE ARE GOING INTO IN _TEMP  ****************************
if defined _mVERBOSE (
	echo.
	echo.^>^>^> %_gG% Changing to _TEMP folder
)
cd _TEMP
if defined _mVERBOSE (
	echo.^>^>^> %_gG% Changed to %CD%
)

echo.
FOR /F "tokens=*" %%A in (..\MOD_MBIN_SOURCE.txt) do (
	set _gMBIN_FILE=%%A
	set _gEXML_FILE=!_gMBIN_FILE:.MBIN=.EXML!
	if not exist "..\MOD\!_gEXML_FILE!" (
		echo.^>^>^> !_gEXML_FILE! does not exist in MOD
		set _gFound=
		if %_bNumberPAKs% GTR 0 (
			if not defined _bBuildMODpakFromPakScript (
				rem getting the EXML from the last PAK, if possible
				FOR /r "..\..\ModScript\" %%G in (*.pak) do (
					echo.
					echo.^>^>^> Looking to Extract %%A from "%%~nxG"
					
					..\psarc.exe extract "..\..\ModScript\%%~nxG" --to="..\..\ModScript\EXTRACTED_PAK" -y "%%A" 1>NUL 2>NUL
					if not exist "..\ModScript\EXTRACTED_PAK\%%A" (
						rem sometimes there is an extra / as the first character!!! (never seen that in NMS PAKs, in user PAK yes!)
						..\psarc.exe extract "..\..\ModScript\%%~nxG" --to="..\..\ModScript\EXTRACTED_PAK" -y "/%%A" 1>NUL 2>NUL
						if not exist "..\..\ModScript\EXTRACTED_PAK\%%A" (
							echo. INFO: Could not find "%%A"
						) else (
							echo|set /p="[INFO]: Found %%A in %%~nxG using [/]">>"..\..\REPORT.txt"
							echo.>>"..\..\REPORT.txt"
							echo. INFO: ***** Found %%A in "%%~nxG" using "/"
							set _gFound=y
						)
					) else (
						echo|set /p="[INFO]: Found %%A in %%~nxG">>"..\..\REPORT.txt"
						echo.>>"..\..\REPORT.txt"
						echo. INFO: ***** Found %%A in "%%~nxG"
						set _gFound=y
					)
					if defined _gFound (
						set _gFound=
						echo.
						echo.^>^>^> Decompiling %%A
						echo.----- [INFO] %%A
						
						Del /f /q /s "..\MBINVersion.txt" 1>NUL 2>NUL
						..\MBINCompiler.exe version -q "..\..\ModScript\EXTRACTED_PAK\%%A">>"..\MBINVersion.txt"
						set /p _gMBINVersion=<..\MBINVersion.txt
						echo.----- [INFO] was compiled using version !_gMBINVersion!
						
						..\MBINCompiler.exe "..\..\ModScript\EXTRACTED_PAK\%%A" -y -f -d "..\..\ModScript\EXMLFILES_PAK\%%A\.." 1>NUL 2>NUL
						Call :LuaEndedOkREMOVE
						..\%_mLUA% ..\CheckMBINCompilerLOG.lua "..\\..\\" "..\\" "Decompiling"
						Call :LuaEndedOk
						echo.-----
						
						rem -- we will copy it to MOD only if it was, at a minimum, created by the same MBINCompiler version initially
						rem -- and we should check for added lines in the NMS EXML vs this one...
						echo.
						echo.^>^>^> Copying PAK's !_gEXML_FILE! to MOD folder...
						xcopy /s /y /h /v "..\..\ModScript\EXMLFILES_PAK\!_gEXML_FILE!" "..\MOD\!_gEXML_FILE!\..\" 1>NUL 2>NUL
					)
				)
			)
		)
	) else (
		echo|set /p="[INFO]: !_gEXML_FILE! already exist in MOD and will be COMBINED">>"..\..\REPORT.txt"
		echo.>>"..\..\REPORT.txt"
		echo.^>^>^> !_gEXML_FILE! already exist in MOD and will be COMBINED
	)
	if not exist "..\MOD\!_gEXML_FILE!" (
		echo|set /p="[INFO]: Getting !_gEXML_FILE! from NMS source PAKs">>"..\..\REPORT.txt"
		echo.>>"..\..\REPORT.txt"
		echo.
		echo.^>^>^> Getting !_gEXML_FILE! from NMS source PAKs
		if not exist "%cd%\EXTRACTED\%%A" (
			CALL :EXTRACT
		)
		REM echo.^>^>^> %_gG% Decompiling only required MBIN Sources to MOD folder
		echo.^>^>^> %_gG% MBINCompiler working...
		echo.----- [INFO] %%A
		..\MBINCompiler.exe "%cd%\EXTRACTED\%%A" -y -f -d "%cd%\DECOMPILED\%%A\.." 1>NUL 2>NUL
		Call :LuaEndedOkREMOVE
		..\%_mLUA% ..\CheckMBINCompilerLOG.lua "..\\..\\" "..\\" "Decompiling"
		Call :LuaEndedOk
		echo.
		xcopy /s /y /h /v "%cd%\DECOMPILED\!_gEXML_FILE!" "..\MOD\!_gEXML_FILE!*" 1>NUL 2>NUL
	)
)
echo.----------------------------------------

cd ..
if defined _mVERBOSE (
	echo.
	echo.^>^>^> %_gG% Changed to %CD%
)
rem ********************************  WE ARE BACK IN MODBUILDER  ****************************

echo.
echo.^>^>^> %_gG% Ending GetFreshSources.bat

goto :eof
rem ---------- WE ARE DONE ---------------------

rem --------------------------------------------
rem subroutine section starts below
rem --------------------------------------------
:EXTRACT
	FOR /F "tokens=*" %%H in (..\MOD_PAK_SOURCE.txt) do (
		if not exist "PAK_SOURCES\%%H" (
			REM echo.
			echo.^>^>^> %_gG% Getting %%H from NMS PCBANKS folder. Please wait...
			xcopy /s /y /h /v "%_gNMS_PCBANKS_FOLDER%%%H" "%CD%\PAK_SOURCES\" >NUL
		)
		echo.^>^>^> %_gG% Looking to Extract required MBIN/EXML from %%H...
		..\psarc.exe extract "PAK_SOURCES\%%H" "%%A" --to="%cd%\EXTRACTED" -y 1>NUL 2>NUL
		if exist "%cd%\EXTRACTED\%%A" (
			echo.^>^>^> %_gG% Found required MBIN
			goto :ENDEXTRACT
		)
	)
	:ENDEXTRACT
	EXIT /B
	
rem --------------------------------------------
rem --------------------------------------------
:DOPAUSE
	if defined _mPAUSE (
		echo.******
		pause
		echo.******
	)
	EXIT /B
	
rem --------------------------------------------
:LuaEndedOk
	if not EXIST  "%_bMASTER_FOLDER_PATH%\MODBUILDER\LuaEndedOK.txt" (
		echo.>>"%_bMASTER_FOLDER_PATH%REPORT.txt"
		echo.    [BUG]: lua.exe generated an ERROR... Please report ALL scripts AND this file to Nexus page>>"%_bMASTER_FOLDER_PATH%REPORT.txt"
		echo.>>"%_bMASTER_FOLDER_PATH%REPORT.txt"
	REM ) else (
		REM if defined _mDEBUG (
			REM echo.        LuaEndedOK
		REM )
	)
	EXIT /B
	
rem --------------------------------------------
:LuaEndedOkREMOVE
	Del /f /q /s "%_bMASTER_FOLDER_PATH%\MODBUILDER\LuaEndedOK.txt" 1>NUL 2>NUL
	EXIT /B
	
rem --------------------------------------------
