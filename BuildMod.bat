SET COMBINE_MODS=0

@echo off
REM ########################################################
REM ############### get last MBINCompiler Build ############
REM ########################################################

xcopy /y /h /v /i "NMS_FOLDER.txt" "MODBUILDER/NMS_FOLDER.txt"
cd MODBUILDER
CALL MBINCompilerDownloader.bat

cd ..\ModScript\
SET ScriptCounter=0
SET NumberScripts=0
for /r %%E in (*.lua) do ( set /A NumberScripts=NumberScripts+1 )

for /r %%M in (*.lua) do (
	SET /A ScriptCounter=ScriptCounter+1
	cd %~dp0\MODBUILDER

	if %ScriptCounter% EQU 1 (
		rmdir /s /q "MOD"
		mkdir "MOD"
	)
	if %COMBINE_MODS% EQU 0 (
		rmdir /s /q "MOD"
		mkdir "MOD"
	)
	
	REM ########################################################
	REM ############### PREPARATION ############################
	REM ########################################################

	echo|set /p=%%M > CurrentModScript.txt
	echo|set /p=%~dp0 > THIS_FOLDER_PATH.txt

	REM dir SCRIPTS\*.lua /b/a-d/o-n  > MODBUILDER\"SCRIPT_LIST.txt"
	lua4.exe LoadScriptAndFilenames.lua

	REM ########################################################
	REM ############### get latest sources from game files #####
	REM ########################################################

	CALL GetFreshSources.bat

	REM ########################################################
	REM ################## APPLY MOD CHANGES ###################
	REM ########################################################

	lua4.exe LoadAndExecuteModScript.lua

	REM ########################################################
	REM ######################## BUILDMOD ######################
	REM ########################################################

	CALL CreateMod.bat

)
echo -----------------------------------------
echo mod builder finished
echo -----------------------------------------
timeout /t 10