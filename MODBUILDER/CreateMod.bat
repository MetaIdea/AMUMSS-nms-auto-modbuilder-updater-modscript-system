@echo off
set /p MOD_FILENAME=<MOD_FILENAME.txt
set /p NMS_FOLDER=<NMS_FOLDER.txt
set NMS_PCBANKS_FOLDER="%NMS_FOLDER%\GAMEDATA\PCBANKS\"
set NMS_MODS_FOLDER=%NMS_PCBANKS_FOLDER%\MODS\
if NOT %COMBINE_MODS% EQU 0 (
	set MOD_FILENAME=CombinedMod.pak
)
REM ########################################################
REM ############### Compile EXML to MBIN ###################
REM ########################################################

cd MOD
@echo on
for /r %%a in (*.exml) do ..\MBINCompiler.exe -y -f "%%a"
@echo off

REM ########################################################
REM ############### Compress to pak file ###################
REM ########################################################

setlocal EnableDelayedExpansion
for /L %%n in (1 1 500) do if "!__cd__:~%%n,1!" neq "" set /a "len=%%n+1"
setlocal DisableDelayedExpansion
(for /r . %%g in (*.MBIN,*.BIN,*.H,*.DDS,*.PC,*.WEM,*.TTF,*.TTC,*.TXT,*.XML) do (
  @echo off
  set "absPath=%%g"
  setlocal EnableDelayedExpansion
  set "relPath=!absPath:~%len%!"
  echo(!relPath!
  endlocal
)) > ..\"input.txt"

@echo on
..\psarc.exe create --overwrite --skip-missing-files --inputfile=..\input.txt --output="..\Builds\%MOD_FILENAME%"
@echo off

REM ########################################################
REM ############### Create Incremental Builds ##############
REM ########################################################

set Destination="..\Builds\IncrementalBuilds"
set Filename=%MOD_FILENAME:.pak=_%
set a=1
:loop
if exist %Destination%\%Filename%(%a%).pak set /a a+=1 && goto :loop
REM xcopy /s /y /h /v "..\Builds\%MOD_FILENAME%" "%Destination%\%Filename%(%a%).pak"
..\psarc.exe create --overwrite --skip-missing-files --inputfile=..\input.txt --output=%Destination%\%Filename%(%a%).pak

REM ########################################################
REM ############### Copy Mod to NMS Mod and root folder ####
REM ########################################################

xcopy /s /y /h /v "..\Builds\%MOD_FILENAME%" "..\..\" 

echo -----------------------------------------------------------

if NOT %COMBINE_MODS% EQU 0 (
	if %NumberScripts% EQU %ScriptCounter% (
		goto :choice
	) else (
		goto :DONT_COPY_TO_NMS_MODS_FOLDER	
	)
)

	:choice
	set /P CHOICE=Would you like to copy the mod %MOD_FILENAME% to your game folder and delete "DISABLEMODS.TXT" ? [y/n]
	if /I "%CHOICE%" EQU "y" ( goto :COPY_TO_NMS_MODS_FOLDER )
	if /I "%CHOICE%" EQU "n" ( goto :DONT_COPY_TO_NMS_MODS_FOLDER )
	goto :choice
	:COPY_TO_NMS_MODS_FOLDER
	mkdir %NMS_MODS_FOLDER%
	xcopy /s /y /h /v ..\Builds\%MOD_FILENAME% %NMS_MODS_FOLDER% 	
	del %NMS_PCBANKS_FOLDER%\DISABLEMODS.TXT 
	:DONT_COPY_TO_NMS_MODS_FOLDER
	
cd ..






