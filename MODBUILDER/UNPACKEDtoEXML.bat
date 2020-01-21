@echo off
SETLOCAL EnableDelayedExpansion ENABLEEXTENSIONS

REM echo. %CD%
REM *********  we are in ModScript  ***********

..\MODBUILDER\mbincompiler.exe convert -y -f -oEXML -dEXMLFILES_PAK --exclude=";" --include="*.MBIN" ".\EXTRACTED_PAK"

FOR /r "EXTRACTED_PAK\" %%G in (*.mbin) do (
	REM echo.%%G
	Del /f /q /s "EXTRACTED_PAK\MBINVersion.txt" 1>NUL 2>NUL
	..\MODBUILDER\MBINCompiler.exe version -q "%%G">>"EXTRACTED_PAK\MBINVersion.txt"
	set /p _gMBINVersion=<EXTRACTED_PAK\MBINVersion.txt
	echo.----- [INFO] %%~nxG was compiled using version !_gMBINVersion!
	Del /f /q /s "EXTRACTED_PAK\MBINVersion.txt" 1>NUL 2>NUL
	
	rem MODBUILDER\Extras\MBINCompiler_OldVersions\MBINCompiler.2.13.0.3.exe
	if exist "..\MODBUILDER\Extras\MBINCompiler_OldVersions\MBINCompiler."!_gMBINVersion!".exe" (
		echo.Found MBINCompiler.!_gMBINVersion!.exe
		..\MODBUILDER\Extras\MBINCompiler_OldVersions\MBINCompiler."!_gMBINVersion!".exe version
	)
)