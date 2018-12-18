@echo off
REM ########################################################
REM ############### get last MBINCompiler Build ############
REM ########################################################

xcopy /y /h /v /i "NMS_FOLDER.txt" "MODBUILDER/NMS_FOLDER.txt"
cd MODBUILDER
CALL MBINCompilerDownloader.bat

rmdir /s /q "MOD"
mkdir "MOD"

cd ..\ModScript\

for /r %%M in (*.lua) do (
	
	cd %~dp0\MODBUILDER
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
pause
timeout /t 10