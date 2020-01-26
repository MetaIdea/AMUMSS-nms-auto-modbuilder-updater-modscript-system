@echo off
if exist DEBUG.txt (
	if not defined _min_subprocess ((cmd /k set _min_subprocess=y ^& %0 %*) & exit )
	echo.################ IN DEBUG MODE ################
	echo.
)

rem All defined variables in BuildMod.bat start with _b (except FOR loop first parameter)
rem so we can easily list them all like this on error, if needed: set _b

SETLOCAL EnableDelayedExpansion ENABLEEXTENSIONS

set _mLUA="lua.exe"
rem -------------  testing for administrator  -------------------------------
set _bMyPath=%CD%
set _bSystem32=%SYSTEMROOT%\system32
if "%_bMyPath%" == "%_bSystem32%" set _bADMIN=1

if DEFINED _bADMIN (
	echo.ERROR: Please do NOT "Run as administrator", AMUMSS will not work^!
	pause
	goto :eof
) 

set _bMyPath=
set _bSystem32=
set _bADMIN=
rem -------------  end testing for administrator  -------------------------------
rem -------------  reding arguments  -------------------------------
rem making the variables made inside the read argument section local
SETLOCAL EnableDelayedExpansion

REM These are the value types. we use them to define all the possible input values for each type separated by commas.
REM We also have a type identified by the word `value` (currently not used but implemented) for the args that don't have restriction on their input. 
REM Do not remove the trailing commas. 
set "flagEnum=ask,y,n,true,false," 
set "combineModeEnum=ask,none,simple,composite,numericSuffix,"
set "copyModeEnum=ask,none,all,some,"

REM all the arguments are defined here using this format: -argumentName:[defaultValue]?[valueTypeIdentifier]
set "args=-includeExtraFiles:ask?flag -rebuildMod:ask?flag -combine:ask?combineMode -copy:ask?copyMode -updateMBINCompiler:ask?flag -checkForConflicts:ask?flag -recreatePakList:ask?flag -recreateMapFileTrees:ask?flag"



REM replace all the `?` with "`" to allow our for loops to work properly.
REM see: https://stackoverflow.com/questions/51644168
set "args=%args:?=`%"



for %%A in (%args%) do (
  for /f "tokens=1,2,* delims=:`" %%G in ("%%A") do (
	rem Creating variables for each argument        
    set "%%G=%%~H"
  )
)

:ReadArg
if not "%~1"=="" ( 
  set "test=!args:*%~1:=!"
  set "search=!test:*%`=!"  
  set argIsValid=y  
  if "!test!"=="!args!" set argIsValid=
  REM all arguments should start with a dash
  set "arg=%~1"  
  if not "!arg:~0,1!"=="-" set argIsValid=
  if not defined argIsValid (   
    echo Error: There is no argument called '%~1'
	pause
    goto :EOF
    REM flagEnum=ask,y,n,true,false 
  ) else if /i "!search:~0,4!"=="flag" (
    set "nextChar=%~2"
    set "nextChar=!nextChar:~0,1!"   
    set noValue=
    if "%~2" =="" set noValue=y     
    if "!nextChar!"=="-" set noValue=y      
    if not defined noValue (      
      set "test=!flagEnum:*%~2,=!"  
      if "!test!"=="!flagEnum!" (        
        echo Error: Invalid value `%~2` for argument `%~1`.
        echo Possible values: !flagEnum:~0,-1!
		pause
        goto :EOF
      ) 
      set isTrue=
      if /i "%~2"=="true" set isTrue=y
      if /i "%~2"=="y" set isTrue=y    
      if defined isTrue (
        set "%~1=y"
      ) else if /i "%~2"=="ask" (
        set "%~1=ask"
      ) else ( 
        set "%~1=n"
      ) 
      shift /1
    ) else (   
      set "%~1=y"
    )    
    REM combineModeEnum=ask,none,simple,composite,numericSuffix
  ) else if /i "!search:~0,11!"=="combineMode" (
    set "nextChar=%~2"
    set "nextChar=!nextChar:~0,1!"   
    set noValue=
    if "%~2" =="" set noValue=y     
    if "!nextChar!"=="-" set noValue=y      
    if not defined noValue (      
      set "test=!combineModeEnum:*%~2,=!"  
      if "!test!"=="!combineModeEnum!" (        
        echo Error: Invalid value `%~2` for argument `%~1`.
        echo Possible values: !combineModeEnum:~0,-1!
		pause
        goto :EOF
      )
      if /i "%~2"=="ask" (
        set "%~1=ask"
      ) else if "%~2"=="none" (
        set "%~1=none"
      ) else if "%~2"=="simple" (
        set "%~1=simple"
      ) else if "%~2"=="composite" (
        set "%~1=composite"
      ) else if "%~2"=="numericSuffix" (
        set "%~1=numericSuffix"
      )
      shift /1
    ) else (   
      set "%~1=simple"
    )    
    REM copyModeEnum=ask,none,all,some
  ) else if /i "!search:~0,8!"=="copyMode" (
    set "nextChar=%~2"
    set "nextChar=!nextChar:~0,1!"   
    set noValue=
    if "%~2" =="" set noValue=y     
    if "!nextChar!"=="-" set noValue=y      
    if not defined noValue (      
      set "test=!copyModeEnum:*%~2,=!"  
      if "!test!"=="!copyModeEnum!" (        
        echo Error: Invalid value `%~2` for argument `%~1`.
        echo Possible values: !copyModeEnum:~0,-1!
		pause
        goto :EOF
      )
      if /i "%~2"=="ask" (
        set "%~1=ask"
      ) else if "%~2"=="none" (
        set "%~1=none"
      ) else if "%~2"=="all" (
        set "%~1=all"
      ) else if "%~2"=="some" (
        set "%~1=some"
      ) 
      shift /1
    ) else (   
      set "%~1=all"
    )    
  ) else if /i "!search:~0,5!"=="value" (
    set "%~1=%~2"
    shift /1
  ) 
  shift /1  
  goto :ReadArg
)
endlocal&(
set "_argIncludeExtraFiles=%-includeExtraFiles%"
set "_argRebuildMod=%-rebuildMod%"
set "_argCombine=%-combine%"
set "_argCopy=%-copy%"
set "_argUpdateMBINCompiler=%-updateMBINCompiler%"
set "_argCheckForConflicts=%-checkForConflicts%"
set "_argRecreatePakList=%-recreatePakList%"
set "_argRecreateMapFileTrees=%-recreateMapFileTrees%"
)
rem ------------- end reding arguments  -------------------------------
echo.  %DATE% %TIME% We are good^!
echo.
pushd "%~dp0\.."
set "_bMASTER_FOLDER_PATH=%CD%"

if exist VERBOSE.txt (set _mVERBOSE=y)
if exist PAUSE.txt (set _mPAUSE=y)
if exist SIMPLE.txt (set _mSIMPLE=y)
if exist Wbertro.txt (set _mWbertro=y)
if exist debugS.txt (set _mdebugS=y)
if exist DEBUG.txt (set _mDEBUG=y)

SET /p _mMasterVersion=<MODBUILDER\Version.txt

echo.  AMUMSS v%_mMasterVersion%
MODBUILDER\%_mLUA% -e print(_VERSION)>temp.txt
set /p _bVersionLua=<temp.txt
echo.  %_bVersionLua%
Del /f /q "temp.txt" 1>NUL 2>NUL

rem --------------   Installed OS   -----------------------------
FOR /F "usebackq tokens=3,4,5" %%i IN (`REG query "hklm\software\microsoft\windows NT\CurrentVersion" /v ProductName`) DO set "_bWinVer=%%i %%j %%k"

Set _bOS_bitness=64
IF %PROCESSOR_ARCHITECTURE% == x86 (
  IF NOT DEFINED PROCESSOR_ARCHITEW6432 Set _bOS_bitness=32
  )

if %_bOS_bitness%==64 (
	echo.  %_bWinVer% 64bit version
	REM need to bring in lua_x64
	xcopy /s /y /h /v ".\MODBUILDER\Extras\Lua5.3.5_x64\*.*" ".\MODBUILDER\" 1>NUL 2>NUL
) else (
	echo.  %_bWinVer% 32bit version
	REM need to bring in lua_x86
	xcopy /s /y /h /v ".\MODBUILDER\Extras\Lua5.3.5_x86\*.*" ".\MODBUILDER\" 1>NUL 2>NUL
)
rem --------------  end Installed OS   -----------------------------
  
echo.
set "_bB=B:"
if defined _mVERBOSE set "_bB=BuildMod.bat:"

if defined _mVERBOSE (
	echo.^>^>^>     In BuildMod.bat
	echo.
)

echo.^>^>^> %_bB% Starting in %CD%

rem **********************  start of NMS_FOLDER DISCOVERY section  *************************
rem try to find the NMS folder path
rem if the user gave a path, try to use it first
echo.
echo.%_bB% Trying to locate Path to NMS_FOLDER...

set /p _bNMS_FOLDER=<NMS_FOLDER.txt 1>NUL 2>NUL
set _bNMS_PCBANKS_FOLDER="%_bNMS_FOLDER%"\GAMEDATA\PCBANKS\

if not exist %_bNMS_PCBANKS_FOLDER%\BankSignatures.bin (
	for %%G in (1,2,3) do (
		if not defined _bFoundNMS (
			if %%G EQU 1 (
				rem NMS on GOG on 32bit
				set _bREGKEY="HKLM\SOFTWARE\GOG.com\Games\1446213994"
				set _bREGVAL="PATH"
			)
			if %%G EQU 2 (
				rem NMS on GOG on 64bit
				set _bREGKEY="HKLM\SOFTWARE\Wow6432Node\GOG.com\Games\1446213994"
				set _bREGVAL="PATH"
			)
			if %%G EQU 3 (
				rem NMS on Steam
				set _bREGKEY="HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 275850"
				set _bREGVAL="InstallLocation"
			)
			rem see https://www.robvanderwoude.com/type.php for more info
			rem CHCP 1252
			
			rem REG QUERY !_bREGKEY! /v !_bREGVAL!
			FOR /F "usebackq tokens=3*" %%A IN (`REG QUERY !_bREGKEY! /v !_bREGVAL!`) DO (
				set _bvalue=%%A %%B
			)
			ECHO !_bvalue!>test.txt
			
			set /p _bNMS_FOLDER=<test.txt
			set _bNMS_PCBANKS_FOLDER="!_bNMS_FOLDER!"\GAMEDATA\PCBANKS\
			if exist !_bNMS_PCBANKS_FOLDER!\BankSignatures.bin (
				echo.
				echo.%_bB% Found Path to NMS_FOLDER...
				set _bFoundNMS=y
			)
		)
	)
)
if defined _bFoundNMS (
	copy /y /v "test.txt" "NMS_FOLDER.txt*" >NUL	
)
Del /f /q "test.txt" 1>NUL 2>NUL

set _bREGKEY=
set _bREGVAL=
set _bvalue=
set _bFoundNMS=

set /p _bNMS_FOLDER=<NMS_FOLDER.txt
set _bNMS_PCBANKS_FOLDER="%_bNMS_FOLDER%"\GAMEDATA\PCBANKS\

if not exist %_bNMS_PCBANKS_FOLDER%\BankSignatures.bin (
	echo.
	echo.********************* PLEASE correct your path in NMS_FOLDER.txt, NMS game files not found ********************
	echo.Found this PATH in [NMS_FOLDER.txt]: "%_bNMS_FOLDER%"
	echo.***** Terminating batch until corrected...
	pause
	exit
) else (
	echo.
	echo.%_bB% Path to NMS_FOLDER is ^>^>^> GOOD ^<^<^<, game files found
)

echo.
echo.^>^>^> %_bB% Copying NMS_FOLDER.txt to update NMS folder path
copy /y /v "NMS_FOLDER.txt" "MODBUILDER/NMS_FOLDER.txt*" >NUL
echo.   "%_bNMS_FOLDER%"
rem **********************  end of NMS_FOLDER DISCOVERY section  *************************

rem ********************  some folder preparation  ***********************
if not exist "%CD%\ModScript" (
	mkdir "%CD%\ModScript\" 2>NUL
)

cd ModScript
CALL :Cleaning_EXTRACTED_PAK
CALL :Cleaning_EXMLFILES_PAK
cd ..

if not exist "%CD%\MapFileTrees" (
	mkdir "%CD%\MapFileTrees\" 2>NUL
)

if not exist "%CD%\ModExtraFilesToInclude" (
	mkdir "%CD%\ModExtraFilesToInclude\" 2>NUL
)

if not exist "%CD%\Builds" (
	mkdir "%CD%\Builds\" 2>NUL
)

if not exist "%CD%\Builds\IncrementalBuilds" (
	mkdir "%CD%\Builds\IncrementalBuilds\" 2>NUL
)
rem ********************  end some folder preparation  ***********************

rem --------------  Check # of scripts present ------------------------------
SET _bNumberScripts=0

rem --------------  and Create a Composite MOD name  ---------------------------------
rem Create a Composite MOD name file while counting how many scripts to run
Del /f /q "MODBUILDER\COMBINED_CONTENT_LIST.txt" 1>NUL 2>NUL
echo|set /p="This mod contains:">"MODBUILDER\COMBINED_CONTENT_LIST.txt"
echo.>>"MODBUILDER\COMBINED_CONTENT_LIST.txt"

SET _bMyTemp2=
FOR /r "%_bMASTER_FOLDER_PATH%\ModScript" %%G in (*.lua) do ( 
	SET /A _bNumberScripts=_bNumberScripts+1
	SET _bMyTemp1=%%~nG
	SET _bMyTemp2=!_bMyTemp2!!_bMyTemp1!+
	echo|set /p="- !_bMyTemp1!">>"MODBUILDER\COMBINED_CONTENT_LIST.txt"
	echo.>>"MODBUILDER\COMBINED_CONTENT_LIST.txt"
)
rem  remove last "+"
SET _bMyTemp2=!_bMyTemp2:~0,-1!
rem 260 - 82(the NMS MODS folder lenght) = 178 max left for filename.pak
SET _bMyTemp2=!_bMyTemp2:~0,178!.pak
echo.%_bMyTemp2%>"MODBUILDER\Composite_MOD_FILENAME.txt"
SET "_bMyTemp1="
SET "_bMyTemp2="
rem --------------  end Create a Composite MOD name  ---------------------------------

if %_bNumberScripts% EQU 0 (
	echo.
	echo.^>^>^>   [INFO] NO .lua Mod Script to Build in ModScript...
	echo.^>^>^>   You may want to put some .lua Mod script in the ModScript folder and retry...
	set _bNoMod=y
	CALL :Cleaning_TEMP
) else (
	SET _bBuildMODpak=y
	CALL :Cleaning_EXML_Helper
)
rem --------------  end Check # of scripts present ------------------------------

rem --------------  Check if ExtraFilesToInclude present ------------------------------
SET _bExtraFiles=0

rem Check if some files also exist in ModExtraFilesToInclude
FOR /r "%_bMASTER_FOLDER_PATH%\ModExtraFilesToInclude" %%G in (*.*) do ( 
	SET /A _bExtraFiles=_bExtraFiles+1
)
if %_bExtraFiles% EQU 0 goto :NO_EXTRAFILES

if not !_argIncludeExtraFiles!==ask (
	if !_argIncludeExtraFiles!==y (	set _bExtraFilesInPAK=y)	
	goto :SKIPCHOICE_EXTRAFILES
)
echo.
echo.^>^>^> There are Extra Files in the ModExtraFilesToInclude folder.  If you INCLUDE them...
echo.^>^>^>      *****  Remember, these files will OVERWRITE any existing ones in the created PAK  *****
CHOICE /c:YN /m "??? Do you want to include them in the created PAK "
if %ERRORLEVEL% EQU 2 goto :NO_EXTRAFILES
if %ERRORLEVEL% EQU 1 SET _bExtraFilesInPAK=y
:SKIPCHOICE_EXTRAFILES

:NO_EXTRAFILES
rem --------------  end Check if ExtraFilesToInclude present ------------------------------

rem --------------  Check # of PAKs present ------------------------------
SET _bNumberPAKs=0

rem Check if some mod PAK also exist in ModScript
FOR /r "%_bMASTER_FOLDER_PATH%\ModScript" %%G in (*.pak) do ( 
	SET /A _bNumberPAKs=_bNumberPAKs+1
	SET _bPAKname=%%~nG
)

if %_bNumberPAKs% GTR 0 (
	echo.
	if %_bNumberPAKs% GTR 1 (
		echo.^>^>^> Detected %_bNumberPAKs% user PAKs in ModScript...
		echo.
		echo.^>^>^>   [WARNING] When more than one PAK are in ModScript
		echo.^>^>^>   [WARNING] Only the last PAK with the same EXML file
		echo.^>^>^>   [WARNING] will contribute to the COMBINED pak
		echo.
	) else (
		echo.-----------------------------------------------------------
		echo.^>^>^> Detected 1 user PAK in ModScript...
	)
	if %_bNumberScripts% GTR 0 (
		echo.^>^>^>      A GENERIC COMBINED MOD pak will be created...
		echo.^>^>^>      If you choose to COPY to your game folder, the PAKs will ALSO be copied there...
		SET _bCOMBINE_MODS=1
		SET _bCOPYtoNMS=NONE
		SET _bPATCH=1
		echo|set /p="- a patch to be used with !_bPAKname!.pak">>"MODBUILDER\COMBINED_CONTENT_LIST.txt"
		echo.>>"MODBUILDER\COMBINED_CONTENT_LIST.txt"
		goto :SIMPLE_MODE
	)
)
rem --------------  end Check # of PAKs present ------------------------------

rem *************************   check if only one pak in ModScript, no script   ************************
if %_bNumberScripts% EQU 0 (
	if %_bNumberPAKs% EQU 1 (
		rem only one pak, no scripts. Extracting ALL files
		SET _bBuildMODpak=
		
		cd ModScript
		rem ******   NOW IN ModScript   ********
		echo.
		echo.^>^>^> %_bB% Unpacking pak to ModScript\EXTRACTED_PAK...
		CALL ..\MODBUILDER\ExtractMODfromPAK.bat

		echo.
		echo.^>^>^> %_bB% Decompiling MBIN to ModScript\EXMLFILES_PAK, if possible with this MBINCompiler version...
		call ..\MODBUILDER\UNPACKEDtoEXML.bat
		rem the MBINs are now decompiled to ModScript\EXTRACTED_PAK, if it was possible
		set _bUNPACKED_DECOMPILED=y
		
		cd ..
		rem ******   BACK IN starting folder   *****

		REM re-calculate number of script
		FOR /r "%_bMASTER_FOLDER_PATH%\ModScript" %%G in (*.lua) do ( 
			SET /A _bNumberScripts=_bNumberScripts+1
		)

		if !_bNumberScripts! EQU 0 goto :NOSCRIPTFOUNDINPAK
	) else (
		goto :BYPASSPAKEXTRACT
	)
) else (
	goto :BYPASSPAKEXTRACT
)
if not !_argRebuildMod!==ask (
	if !_argRebuildMod!==y ( SET _bBuildMODpak=y ) else ( SET _bNumberScripts=0 )
	GOTO :SKIPCHOICE_REBUILDMOD
)
echo.-----------------------------------------------------------
echo.
echo.^>^>^> At least one script was found in the pak
CHOICE /c:YN /m "??? Do you want to rebuild the MOD pak using that script "
if %ERRORLEVEL% EQU 2 SET _bNumberScripts=0
if %ERRORLEVEL% EQU 1 SET _bBuildMODpak=y
:SKIPCHOICE_REBUILDMOD

if defined _bBuildMODpak (
	set _bNoMod=
	set _bBuildMODpakFromPakScript=y
	REM we use the scripts as normal scripts and forget about the pak
	xcopy /s /y /h /v "ModScript\EXTRACTED_PAK\*.lua" "Modscript\..\" 1>NUL 2>NUL
)
rem *************************   end check if only one pak in ModScript, no script   ************************

:NOSCRIPTFOUNDINPAK
echo.
echo.^>^>^>  [INFO] No script was found in this pak

pause

:BYPASSPAKEXTRACT
rem -------- user options start here -----------
rem on 0, treat as an INDIVIDUAL mod
rem on 1, treat as a generic combined mod
rem on 2, treat as a DISTINCT combined mod
rem on 3, treat as an INDIVIDUAL mod, the name being like Mod1+Mod2+Mod3.pak, a COMPOSITE mod
SET _bCOMBINE_MODS=0
SET _bCOPYtoNMS=NONE
CALL :DOPAUSE	

if defined _bNoMod goto :EXECUTE
if defined _mSIMPLE goto :SIMPLE_MODE 
if %_bNumberScripts% EQU 1 goto :SIMPLE_MODE
REM combineModeEnum=ask,none,simple,composite,numericSuffix
if not !_argCombine!==ask (
	if !_argCombine!==simple (
		SET _bCOMBINE_MODS=1
	) else if !_argCombine!==numericSuffix (	
		SET _bCOMBINE_MODS=2
	) else if !_argCombine!==composite (
		SET _bCOMBINE_MODS=3
	) else if !_argCombine!==none (
		goto :SKIPCHOICE_COMBINE
	)
	goto :SKIPCHOICE_COPY	
)
echo.
echo.^>^>^> INDIVIDUAL PAKs may or may not work together depending on the EXML files they change
echo.    If they modify the same original EXML files, the last one loaded will win and the other changes will be lost...
echo.
echo.    You may use INDIVIDUAL PAKs when they don't interfere with each other
echo.
echo.^>^>^> COMBINED PAKs will try to keep, as much as possible, all changes made to a particular EXML file by re-using it during PAK creation
echo.    Only changes made to the same exact values of an EXML will reflect only the last mod
echo.
CHOICE /c:yn /m "??? Do you want to create a COMBINED mod[Y] or INDIVIDUAL mod(s)[N] "
if %ERRORLEVEL% EQU 2 goto :CONTINUE_EXECUTION1
REM if %ERRORLEVEL% EQU 1 SET _bCOMBINE_MODS=1

echo.
echo.^>^>^> A COMPOSITE combined MOD name has a length limit of less than 178 characters (excess will be truncated)
set /p _bCompositeName=<"MODBUILDER\Composite_MOD_FILENAME.txt"
echo.    It would be...
echo.      "%_bCompositeName%"
echo.               ...in this case
CHOICE /c:yn /m "??? Do you want to use a COMPOSITE combined MOD named just like that "
if %ERRORLEVEL% EQU 2 goto :COMBINEDTYPE
if %ERRORLEVEL% EQU 1 SET _bCOMBINE_MODS=3
goto :CONTINUE_EXECUTION2

:COMBINEDTYPE
echo.
echo.^>^>^> A COMBINED MOD name can be like ZZZCombinedMod_(x).pak (where x is 0 to 9)
echo.                         ...or like ZZZCombinedMod_DATE-TIME.pak...
echo.
CHOICE /c:yn /m "??? Do you want to use a NUMERIC suffix[Y] or the current DATE-TIME[N] to differentiate your mod name "
if %ERRORLEVEL% EQU 2 SET _bCOMBINE_MODS=1
if %ERRORLEVEL% EQU 1 SET _bCOMBINE_MODS=2
goto :CONTINUE_EXECUTION2
:SKIPCHOICE_COMBINE

:CONTINUE_EXECUTION1
REM copyModeEnum=ask,none,all,some
if not !_argCopy!==ask (
	if !_argCopy!==all (
		SET _bCOPYtoNMS=ALL
	) else if !_argCopy!==some (
		SET _bCOPYtoNMS=SOME
	) else if !_argCopy!==none (
		SET _bCOPYtoNMS=NONE
	)
	goto :SKIPCHOICE_COPY
)
echo.
CHOICE /c:NSA /m "??? Would you like or [N]ot to COPY [S]ome or [A]ll Created Mod PAKs to your game folder and DELETE [DISABLEMODS.TXT] "
if %ERRORLEVEL% EQU 3 SET _bCOPYtoNMS=ALL
if %ERRORLEVEL% EQU 2 SET _bCOPYtoNMS=SOME
if %ERRORLEVEL% EQU 1 SET _bCOPYtoNMS=NONE
:SKIPCHOICE_COPY

:CONTINUE_EXECUTION2
if %_bCOMBINE_MODS% NEQ 0 SET _bCOPYtoNMS=SOME
goto :EXECUTE

:SIMPLE_MODE
if %_bNumberScripts% EQU 0 goto :EXECUTE
REM copyModeEnum=ask,none,all,some
if not !_argCopy!==ask (
	if !_argCopy!==all (
		SET _bCOPYtoNMS=ALL
	) else if !_argCopy!==some (
		SET _bCOPYtoNMS=ALL
	) else if !_argCopy!==none (
		SET _bCOPYtoNMS=NONE
	)
	goto :SKIPCHOICE_SIMPLECOPY
)
echo.
CHOICE /c:YN /m "??? Would you like to COPY the created Mod PAKs to your game folder and DELETE [DISABLEMODS.TXT] "
if %ERRORLEVEL% EQU 2 SET _bCOPYtoNMS=NONE
if %ERRORLEVEL% EQU 1 SET _bCOPYtoNMS=ALL
rem -------- user options end here -----------
:SKIPCHOICE_SIMPLECOPY

:EXECUTE

rem --------------------------------------------

if not exist "%CD%\CreatedModPAKs" (
	mkdir "%CD%\CreatedModPAKs\" 2>NUL
)
Del /f /q /s ".\CreatedModPAKs\*.*" 1>NUL 2>NUL

Del /f /q "%_bMASTER_FOLDER_PATH%\MODBUILDER\LuaEndedOk.txt" 1>NUL 2>NUL
Del /f /q "REPORT.txt" 1>NUL 2>NUL

Del /f /q "TempScript.lua" 1>NUL 2>NUL
Del /f /q "TempTable.lua" 1>NUL 2>NUL

REM CALL :Cleaning_EXML_Helper

cd MODBUILDER
pushd "%CD%"

rem *********************  NOW IN MODBUILDER  *******************
echo|set /p="%_bMASTER_FOLDER_PATH%\">MASTER_FOLDER_PATH.txt
rem always Cleaning _TEMP at the start of a new run
CALL :Cleaning_TEMP

if defined _mVERBOSE (
	echo.
	echo.^>^>^> %_bB% Changed to %CD%
)

del /f /q OnlyOneScript.txt 1>NUL 2>NUL
if %_bNumberScripts% EQU 1 (
	echo|set /p="">OnlyOneScript.txt
)

rem ****************************  start MBINCompiler.exe update section  ******************************
if defined _mSIMPLE goto :SIMPLE_MODE1
echo.
if not exist "MBINCompiler.exe" CALL MBINCompilerDownloader.bat & goto :CONTINUE_EXECUTION2
if not !_argUpdateMBINCompiler!==ask (
	if !_argUpdateMBINCompiler!==y (
		goto :SKIPCHOICE_UPDATECOMPILER
	) else (
		goto :CONTINUE_EXECUTION2
	)
)
Del /f /q /s "MBINCompilerVersion.txt" 1>NUL 2>NUL
MBINCompiler.exe version -q >>MBINCompilerVersion.txt
set /p _bMBINCompilerVersion=<MBINCompilerVersion.txt
echo.^>^>^> Your current MBINCompiler is version: %_bMBINCompilerVersion%

echo.
CHOICE /c:yn /t 30 /d y /m "??? Do you need to UPDATE MBINCompiler.exe, (default Y in 30 seconds)"
if %ERRORLEVEL% EQU 2 goto :CONTINUE_EXECUTION2
:SKIPCHOICE_UPDATECOMPILER

:SIMPLE_MODE1
echo.
echo.^>^>^> %_bB% Calling MBINCompilerDownloader.bat: getting latest MBINCompiler from Web

:RETRY_MBINCompiler
CALL MBINCompilerDownloader.bat
echo.
Del /f /q /s "MBINCompilerVersion.txt" 1>NUL 2>NUL
MBINCompiler.exe version -q >>"MBINCompilerVersion.txt"
set /p _bMBINCompilerVersion=<MBINCompilerVersion.txt
echo.^>^>^> Your new MBINCompiler is version: %_bMBINCompilerVersion%

:CONTINUE_EXECUTION2
if not exist "MBINCompiler.exe" goto :RETRY_MBINCompiler
rem ****************************  end MBINCompiler.exe update section  ******************************

if defined _mVERBOSE (
	echo.
	echo.^>^>^> 1 - Back in BuildMod.bat
)

rem -------------   Conflict detection or not?  -------------
if not !_argCheckForConflicts!==ask (
	if !_argCheckForConflicts!==y ( set _bCheckMODSconflicts= 1 ) else ( set _bCheckMODSconflicts= 2 )
	GOTO :SKIPCHOICE_CHECKFORCONFLICT
)
echo.
CHOICE /c:yn /m "??? Would you like to check your NMS MODS for conflict?"
if %ERRORLEVEL% EQU 2 set _bCheckMODSconflicts=2
if %ERRORLEVEL% EQU 1 set _bCheckMODSconflicts=1
:SKIPCHOICE_CHECKFORCONFLICT
rem -------------   end Conflict detection or not?  -------------

rem **************************  start PAK_LISTs creation section  ********************************
echo.
echo.^>^>^> Checking NMS PCBANKS PAK file lists existence...
REM echo.

REM check if we need to re-create the list
CALL GetDateTimePCBANKS.bat

if exist "pak_list.txt" SET _gPAKlistExist=y

if defined _gPAKlistExist goto :Ask

echo.
echo.^>^>^> [INFO} NMS PCBANKS was updated...
echo.
set _bNMSUpdated=1

CALL PSARC_LIST_PAKS.BAT
REM if defined _mVERBOSE (
	REM Call :LuaEndedOkREMOVE
	REM %_mLUA% FormatPAKlist.lua
	REM Call :LuaEndedOk
REM )

goto :NoNeedToAsk

:Ask
if not exist "..\DEBUG.txt" goto :NoNeedToAsk
if not !_argRecreatePakList!==ask (
	if !_argRecreatePakList!==y ( set _bRecreatePAKList=1) else ( set _bRecreatePAKList=2)
	GOTO :SKIPCHOICE_RECREATEPAKLIST
)
echo.
REM echo.^>^>^> If there was a NMS update, it is recommended to recreate this list
CHOICE /c:yn /m "??? Do you want to RECREATE the NMS PAK file list"
if %ERRORLEVEL% EQU 2 set _bRecreatePAKList=2
if %ERRORLEVEL% EQU 1 set _bRecreatePAKList=1
:SKIPCHOICE_RECREATEPAKLIST

if %_bRecreatePAKList% EQU 1 (
	CALL PSARC_LIST_PAKS.BAT
	REM if defined _mVERBOSE (
		REM Call :LuaEndedOkREMOVE
		REM %_mLUA% FormatPAKlist.lua
		REM Call :LuaEndedOk
		REM )
)

:NoNeedToAsk
SET _gPAKlistExist=
SET _bRecreatePAKList=
rem **************************  end PAK_LISTs creation section  ********************************

rem **************************  MapFileTrees creation section  ********************************
echo.
if defined _bNMSUpdated (
	echo.^>^>^> There was a NMS update, it is recommended to recreate the MapFileTrees files
	echo.
	echo.^>^>^> Some of your MapFileTrees files may be outdated
	echo.^>^>^>    You can recreate them using the script MapFileTree_UPDATER.lua
	echo.^>^>^>    To update a specific file, add it to the script
	echo.^>^>^> All other MapFileTrees will be updated as you process other scripts
)

if defined _mWbertro (
	set _bRecreateMapFileTrees=1
	goto :START
)
if not !_argRecreateMapFileTrees!==ask (
	if !_argRecreateMapFileTrees!==y ( set _bRecreateMapFileTrees=1)
	GOTO :SKIPCHOICE_RECREATEMAPLIST
)
CHOICE /c:yn /m "??? Do you want to (RE)CREATE the MapFileTrees files DURING script processing"
if %ERRORLEVEL% EQU 1 (set _bRecreateMapFileTrees=1)
:SKIPCHOICE_RECREATEMAPLIST
rem **************************  end MapFileTrees creation section  ********************************

:START
rem ------  START of automatic processing: start the clock  -----------------------
Call :LuaEndedOkREMOVE
%_mLUA% StartTime.lua "..\\" ""
Call :LuaEndedOk

rem -------------  Start REPORTing  -----------------------------------------------
echo|set /p="[INFO]: AMUMSS v%_mMasterVersion%">>"..\REPORT.txt"
echo.>>"..\REPORT.txt"
echo|set /p="[INFO]: using %_bVersionLua%">>"..\REPORT.txt"
echo.>>"..\REPORT.txt"

if %_bOS_bitness%==64 (
	echo|set /p="[INFO]: on %_bWinVer% 64bit">>"..\REPORT.txt"
	echo.>>"..\REPORT.txt"
) else (
	echo|set /p="[INFO]: on %_bWinVer% 32bit">>"..\REPORT.txt"
	echo.>>"..\REPORT.txt"
)

echo|set /p="[INFO]: MBINCompiler v%_bMBINCompilerVersion%">>"..\REPORT.txt"
echo.>>"..\REPORT.txt"

echo.>>"..\REPORT.txt"

del /f /q LoadScriptAndFilenamesERROR.txt 1>NUL 2>NUL

del /f /q MBIN_PAKS.txt 1>NUL 2>NUL
echo|set /p="">MBIN_PAKS.txt
echo.>>"MBIN_PAKS.txt"

del /f /q MODS_pak_list.txt 1>NUL 2>NUL
echo|set /p="">MODS_pak_list.txt

REM get list of files in paks in MODS folder
if %_bCheckMODSconflicts% EQU 1 CALL PSARC_LIST_PAKS_MODS.BAT

if %_bNumberPAKs% GTR 0 (
	echo.
	CALL PSARC_LIST_ModScriptPAKS.BAT
	echo.
	echo.---------------------------------------------------------

	if %_bNumberPAKs% GTR 1 (
		echo.^>^>^> XXXXX     There are %_bNumberPAKs% user PAKs in ModScript    XXXXX
		echo|set /p=".   [WARNING]: There are %_bNumberPAKs% user PAKs in ModScript">>"..\REPORT.txt"
		echo.>>"..\REPORT.txt"
		REM echo.>>"..\REPORT.txt"
		echo.^>^>^>         When more than one PAK is in ModScript
		echo|set /p="[INFO]:         When more than one PAK is in ModScript">>"..\REPORT.txt"
		echo.>>"..\REPORT.txt"
		echo.^>^>^>        Only the last PAK with the same EXML file
		echo|set /p="[INFO]:         Only the last PAK with the same EXML file">>"..\REPORT.txt"
		echo.>>"..\REPORT.txt"
		echo.^>^>^>          will contribute to the COMBINED pak
		echo|set /p="[INFO]:         will contribute to the COMBINED pak!">>"..\REPORT.txt"
		echo.>>"..\REPORT.txt"
	) else (
		echo.^>^>^>      There is %_bNumberPAKs% user PAK in ModScript
		echo|set /p="[INFO]: There is %_bNumberPAKs% user PAK in ModScript">>"..\REPORT.txt"
		echo.>>"..\REPORT.txt"

		if defined _bUNPACKED_DECOMPILED (
			echo.>>"..\REPORT.txt"		
			echo|set /p="[INFO]: Unpacked pak to ModScript\EXTRACTED_PAK">>"..\REPORT.txt"
			echo.>>"..\REPORT.txt"
			echo|set /p="[INFO]: Decompiled MBIN to ModScript\EXMLFILES_PAK (if it was possible with this MBINCompiler version)">>"..\REPORT.txt"
			echo.>>"..\REPORT.txt"
		)
	)
	echo.>>"..\REPORT.txt"
	if %_bNumberScripts% GTR 0 (
		echo.^>^>^> So, we are making a GENERIC COMBINED MOD PAK...	
		echo|set /p="[INFO]:   A GENERIC COMBINED MOD will be created...">>"..\REPORT.txt"
		echo.>>"..\REPORT.txt"
		if defined _bExtraFilesInPAK (
			echo.^>^>^>      Extra Files in ModExtraFilesToInclude will be included
			echo|set /p="[INFO]:   Extra Files in ModExtraFilesToInclude will be included">>"..\REPORT.txt"
			echo.>>"..\REPORT.txt"
		) else (
			if %_bExtraFiles% GTR 0 (
				echo.^>^>^>      Extra Files in ModExtraFilesToInclude will NOT be included
				echo|set /p="[INFO]:   Extra Files in ModExtraFilesToInclude will NOT be included">>"..\REPORT.txt"
				echo.>>"..\REPORT.txt
			)
		)
		if %_bCOPYtoNMS%==NONE (
			echo.^>^>^>      It will NOT be copied to NMS MOD folder
			echo|set /p="[INFO]:   It will NOT be copied to NMS MOD folder">>"..\REPORT.txt"
		)
		if %_bCOPYtoNMS%==ALL (
			if %_bNumberPAKs% GTR 1 (
				echo.^>^>^>      and will be copied with the user PAKs to NMS MOD folder
				echo|set /p="[INFO]:   and will be copied with the user PAKs to NMS MOD folder">>"..\REPORT.txt"
			) else (
				echo.^>^>^>      and will be copied with the user PAK to NMS MOD folder
				echo|set /p="[INFO]:   and will be copied with the user PAK to NMS MOD folder">>"..\REPORT.txt"
			)
		)
	)
	echo.>>"..\REPORT.txt"
	echo.>>"..\REPORT.txt"
) else (
	if defined _bNoMod goto :SIMPLE_MODE2
	echo.
	echo.---------------------------------------------------------
	if %_bCOMBINE_MODS% EQU 0 (
		echo.^>^>^> So, we are making INDIVIDUAL MOD PAKs...
		echo|set /p="[INFO]:   INDIVIDUAL MOD PAKs will be created...">>"..\REPORT.txt"
		echo.>>"..\REPORT.txt"
	)
	if %_bCOMBINE_MODS% EQU 1 (
		echo.^>^>^> So, we are making a GENERIC COMBINED MOD PAK...	
		echo|set /p="[INFO]:   A GENERIC COMBINED MOD will be created...">>"..\REPORT.txt"
		echo.>>"..\REPORT.txt"
	)
	if %_bCOMBINE_MODS% EQU 2 (
		echo.^>^>^> So, we are making one or more DISTINCT COMBINED MOD PAK...	
		echo|set /p="[INFO]:   One or more DISTINCT COMBINED MOD PAK will be created...">>"..\REPORT.txt"
		echo.>>"..\REPORT.txt"
	)
	if %_bCOMBINE_MODS% EQU 3 (
		echo.^>^>^> So, we are making a COMPOSITE-NAME COMBINED MOD PAK...	
		echo|set /p="[INFO]:   A COMPOSITE-NAME COMBINED MOD will be created...">>"..\REPORT.txt"
		echo.>>"..\REPORT.txt"
	)
	if defined _bExtraFilesInPAK (
		echo.^>^>^>      Extra Files in ModExtraFilesToInclude will be included
		echo|set /p="[INFO]:   Extra Files in ModExtraFilesToInclude will be included">>"..\REPORT.txt"
		echo.>>"..\REPORT.txt"
	) else (
		if %_bExtraFiles% GTR 0 (
			echo.^>^>^>      Extra Files in ModExtraFilesToInclude will NOT be included
			echo|set /p="[INFO]:   Extra Files in ModExtraFilesToInclude will NOT be included">>"..\REPORT.txt"
			echo.>>"..\REPORT.txt
		)
	)
	if %_bCOPYtoNMS%==NONE (
		echo.^>^>^>      and NONE will be copied to NMS MOD folder
		echo|set /p="[INFO]:   and NONE will be copied to NMS MOD folder">>"..\REPORT.txt"
	)
	if %_bCOPYtoNMS%==ALL (
		echo.^>^>^>      and ALL will be copied to NMS MOD folder
		echo|set /p="[INFO]:   and ALL will be copied to NMS MOD folder">>"..\REPORT.txt"
	)
	echo.>>"..\REPORT.txt"
	REM echo.>>"..\REPORT.txt"
)

echo.---------------------------------------------------------
if defined _mSIMPLE goto :SIMPLE_MODE2 
if defined _min_subprocess goto :SIMPLE_MODE2 
REM TODO: consider adding an option to bypass this timeout
timeout /t 5

:SIMPLE_MODE2 
rem Bugs: https://ss64.com/nt/goto.html
rem Using GOTO within parenthesis - including FOR and IF commands - will break their context
rem remarks with :: do not work in FOR loops
rem --------------------------------------------

if not defined _bBuildMODpak goto :ENDING

echo.
echo.^>^>^> %_bB% Number of scripts to build: %_bNumberScripts%

SET _bScriptCounter=0

rem --------  processing loop only if scripts are present -------------
FOR /r "%_bMASTER_FOLDER_PATH%\ModScript" %%G in (*.lua) do (
	set "_bScriptName=%%~nxG"
	rem making sure we are in MODBUILDER
	popd
	pushd "%CD%"

	if defined _mVERBOSE (
		echo.
		echo.^>^>^> %_bB% In directory !CD!
	)

	echo.
	echo.^>^>^> %_bB% ************** ^>^>^> In Mod Building Loop ^<^<^< **************
	echo.
	SET /A _bScriptCounter=_bScriptCounter+1
	echo.^>^>^> %_bB% Starting to process script #!_bScriptCounter! of %_bNumberScripts% [%%~nxG]
	echo.>>"..\REPORT.txt"
	echo|set /p="[INFO]: ========================================================================================">>"..\REPORT.txt"
	echo.>>"..\REPORT.txt"
	echo|set /p="[INFO]: Starting to process script #!_bScriptCounter! of %_bNumberScripts% [%%~nxG]">>"..\REPORT.txt"
	echo.>>"..\REPORT.txt"
	
	rem ########################################################
	rem ############### PREPARATION ############################
	rem ########################################################
	
	REM CALL :Cleaning_ModScript
	CALL :Cleaning_MOD

	if defined _mVERBOSE (
		echo.
		echo.^>^>^> %_bB% Changing to directory MODBUILDER
	)
	cd /d %_bMASTER_FOLDER_PATH%\MODBUILDER
	if defined _mVERBOSE (
		echo.^>^>^> %_bB% Changed to !CD!
	)
	echo.
	echo.^>^>^> 2 - In %_bB% PREPARATION
	echo|set /p="%%G">CurrentModScript.txt
	CALL :DOPAUSE	
	
	rem copy script file to MOD, it will be part of the created pak
	xcopy /s /y /h /v "%%G" ".\MOD\%%~nxG*" 1>NUL 2>NUL

	echo.^>^>^> %_bB% Executing Lua with LoadScriptAndFilenames.lua, Please wait...
	rem switch ON
	echo|set /p="">Show.txt
	rem switch ON
	echo|set /p="">Conflicts.txt
	
	rem alloy scripts to bypass this first pass
	set SkipScriptFirstCheck=0
	
	del /f /q LoadScriptAndFilenamesERROR.txt 1>NUL 2>NUL
	Call :LuaEndedOkREMOVE
	%_mLUA% LoadScriptAndFilenames.lua
	Call :LuaEndedOk
	IF EXIST "LoadScriptAndFilenamesERROR.txt" set _bErrorLoadingScript=y

	rem Do not alloy bypass anymore
	set SkipScriptFirstCheck=
	
	rem switch OFF
	del /f /q Show.txt 1>NUL 2>NUL
	rem switch OFF
	del /f /q Conflicts.txt 1>NUL 2>NUL

	IF NOT DEFINED _bErrorLoadingScript (
		
		rem ########################################################
		rem ############### get latest sources from game files #####
		rem ########################################################
		
		echo.
		echo.^>^>^> 3 - Back in %_bB% get latest sources from game files
		echo.^>^>^> %_bB% Calling GetFreshSources.bat
		
		CALL GetFreshSources.bat

		CALL :DOPAUSE
		rem ########################################################
		rem ################## APPLY MOD CHANGES ###################
		rem ########################################################
		
		echo.
		echo.^>^>^> 4 - Back in %_bB% APPLY SCRIPT MOD CHANGES
		echo.^>^>^> %_bB% Applying User Lua Script Changes with LoadAndExecuteModScript.lua, Please wait...
		
		Call :LuaEndedOkREMOVE
		%_mLUA% LoadAndExecuteModScript.lua
		Call :LuaEndedOk
		IF EXIST "LoadScriptAndFilenamesERROR.txt" (
			set _bErrorLoadingScript=y
		)
		
		IF NOT DEFINED _bErrorLoadingScript (

			CALL :DOPAUSE
			rem ########################################################
			rem ######################## BUILDMOD ######################
			rem ########################################################
			
			if %_bCOMBINE_MODS% NEQ 0 (
				if %_bNumberScripts% EQU !_bScriptCounter! (
					echo.
					echo.^>^>^> %_bB% INFO: LAST script of Combined Mod, Building MOD now...
					if defined _mVERBOSE (
						echo.
						echo.^>^>^> 5 - Back in %_bB% Recreate MBINs and PAK file
					)
					echo.^>^>^> %_bB% Calling CreateMod.bat
					
					Call :LuaEndedOkREMOVE
					%_mLUA% GetDateTime.lua "..\\" ".\\"
					Call :LuaEndedOk
					CALL CreateMod.bat
				) else (
					echo.
					echo.^>^>^> %_bB% INFO: Combined Mod ACTIVE: Delaying Building MOD until the end...
					echo|set /p="[INFO]: Combined Mod ACTIVE: Delaying Building MOD until the end...">>"..\REPORT.txt"
					echo.>>"..\REPORT.txt"
					echo.>>"..\REPORT.txt"
				)
			) else (
				if defined _mVERBOSE (
					echo.
					echo.^>^>^> 5 - Back in %_bB% Recreating MBINs and PAK file
				)
				echo.
				echo.^>^>^> %_bB% Calling CreateMod.bat
				
				Call :LuaEndedOkREMOVE
				%_mLUA% GetDateTime.lua "..\\" ".\\"
				Call :LuaEndedOk
				CALL CreateMod.bat
			)
		)
	)
	CALL :DOPAUSE
	IF DEFINED _bErrorLoadingScript (
		echo|set /p="    [ENDED THIS SCRIPT PROCESSING]: ========================================================================================">>"..\REPORT.txt"
		echo.>>"..\REPORT.txt"
		echo.
		echo.-----------------------------------------------------------
		echo.^>^>^>            Scripts processed: !_bScriptCounter!
		echo.^>^>^>     Total scripts to process: %_bNumberScripts%
		echo.-----------------------------------------------------------
		echo.
	) else (
		REM echo.
		echo.^>^>^> %_bB% Updating EXML_Helper\MOD_EXML...
		echo.^>^>^> %_bB% Note that the MOD_EXML files WILL BE the latest ones based on script processing order
		
		cd "%_bMASTER_FOLDER_PATH%"
		xcopy /f /s /y /h /e /v /i /j /c "MODBUILDER\MOD\*.EXML" "EXML_Helper\MOD_EXML\" 1>NUL 2>NUL
		cd "%_bMASTER_FOLDER_PATH%\MODBUILDER"
	)
	set _bErrorLoadingScript=
	del /f /q LoadScriptAndFilenamesERROR.txt 1>NUL 2>NUL
)

:ENDING
echo.
echo.^>^>^> Ending phase...

if defined _mVERBOSE (
	echo.
	echo.^>^>^> %_bB% In %CD%
)

cd "%_bMASTER_FOLDER_PATH%\MODBUILDER"
rem WE ARE IN MODBUILDER

if defined _mVERBOSE (
	echo.
	echo.^>^>^> %_bB% In %CD%
)

rem WE ARE GOING INTO MASTER_FOLDER_PATH
cd ..

if defined _mVERBOSE (
	echo.^>^>^> %_bB% Changed to %CD%
)

if %_bNumberScripts% GTR 0 (
	echo.
	echo.^>^>^> %_bB% Updating EXML_Helper\ORG_EXML...
	xcopy /s /y /h /e /v /i /j /c "MODBUILDER\_TEMP\DECOMPILED\*.EXML" "EXML_Helper\ORG_EXML\" 1>NUL 2>NUL
)

echo.
echo.-----------------------------------------
echo.^>^>^> %_bB% AMUMSS finished
echo.-----------------------------------------
echo.

if defined _bNoMod (
	echo.^>^>^>   [WARNING] No .lua Mod Script found...
	echo.^>^>^>   You may want to put some .lua Mod script in the ModScript folder and retry...

	echo|set /p=".   [WARNING]: No .lua Mod Script found...">>"REPORT.txt"
	echo.>>"REPORT.txt"
	echo|set /p="[INFO]: You may want to put some .lua Mod script in the ModScript folder and retry...">>"REPORT.txt"
	echo.>>"REPORT.txt"
	echo.>>"REPORT.txt"

) else (
	if not defined _bErrorLoadingScript (
		echo.>>"REPORT.txt"
		echo.^>^>^> Created PAKs are in local folder ^>^>^> CreatedModPAKs ^<^<^<
		echo.^>^>^> Backups in ^>^>^> Builds ^<^<^< and ^>^>^> Builds\IncrementalBuilds ^<^<^<

		echo|set /p="[INFO]: Created PAKs are in local folder >>> CreatedModPAKs <<<">>"REPORT.txt"
		echo.>>"REPORT.txt"
		echo|set /p="[INFO]: Backups in >>> Builds <<< and >>> Builds\IncrementalBuilds <<<">>"REPORT.txt"
		echo.>>"REPORT.txt"
		echo.>>"REPORT.txt"
		echo.>>"REPORT.txt"
		echo|set /p="[INFO]: END OF PROCESSING">>"REPORT.txt"
		echo.>>"REPORT.txt"
		echo|set /p="[INFO]: Total scripts processed: %_bNumberScripts%">>"REPORT.txt"
		echo.>>"REPORT.txt"
		echo.>>"REPORT.txt"
		echo.>>"REPORT.txt"
	)
)

Call :LuaEndedOkREMOVE
.\MODBUILDER\%_mLUA% ".\MODBUILDER\CheckCONFLICTLOG.lua" ".\\" ".\\MODBUILDER\\" "" %_bCheckMODSconflicts%
Call :LuaEndedOk

REM echo.
echo.              ^>^>^> FINAL REPORT  ^<^<^<
echo.            ^>^>^> See "REPORT.txt"  ^<^<^<

if defined _bErrorLoadingScript (
	echo.
	echo.  ^>^>^>  INTERRUPTED / INCOMPLETE PROCESSING  ^<^<^<
	REM echo.
)

echo.>>"REPORT.txt"
echo|set /p="[INFO]:                 >>> FINAL REPORT  <<<">>"REPORT.txt"
echo.>>"REPORT.txt"

if defined _bErrorLoadingScript (
	echo.>>"REPORT.txt"
	echo|set /p="[INFO]:     >>>  INTERRUPTED / INCOMPLETE PROCESSING  <<<">>"REPORT.txt"
	echo.>>"REPORT.txt"
)

REM echo.>>"REPORT.txt"

Call :LuaEndedOkREMOVE
.\MODBUILDER\%_mLUA% ".\MODBUILDER\CheckREPORTLOG.lua" ".\\" ".\\MODBUILDER\\"
Call :LuaEndedOk
echo.        ^>^>^> See "REPORT.txt"  ^<^<^<

REM get time to process
Call :LuaEndedOkREMOVE
.\MODBUILDER\%_mLUA% ".\MODBUILDER\EndTime.lua" ".\\" ".\\MODBUILDER\\"
Call :LuaEndedOk
Call :LuaEndedOkREMOVE
.\MODBUILDER\%_mLUA% ".\MODBUILDER\DiffTime.lua" ".\\" ".\\MODBUILDER\\"
Call :LuaEndedOk

echo.

if defined _bUNPACKED_DECOMPILED (
	echo.^>^>^> You can examine the pak content in ModScript EXTRACTED_PAK and EXMLFILES_PAK folders
	echo.
)

if defined _min_subprocess (
	echo.################ IN DEBUG MODE ################
	echo.
	if exist DEBUG.txt (set _)
)

If defined _mWbertro (
	Call :LuaEndedOkREMOVE
	.\MODBUILDER\%_mLUA% ".\MODBUILDER\CheckGlobalReplacements.lua" ".\\" ".\\MODBUILDER\\"
	Call :LuaEndedOk
)

if not exist DEBUG.txt (pause)
rem timeout /t 5

REM cleanup %_mLUA% errors
REM del /f /q LuaEndedOk.txt
del /f /q "MODBUILDER\LuaEndedOk.txt"
REM del /f /q "MODBUILDER\MOD\LuaEndedOk.txt"
REM del /f /q "MODBUILDER\_TEMP\LuaEndedOk.txt"
REM end cleanup %_mLUA% errors

rem ****seekker*****************************************************
rem *********************************************************
If defined _mdebugS goto :eof 
rem ---- only runs if debugS.txt not present

rem --- delete created folders
REM rmdir /s /q EXML --not removed, keep it for inspection and as a help for users
rmdir /s /q MODBUILDER\_TEMP
rmdir /s /q MODBUILDER\MOD


rem --- delete created temp text file
del /f /q MODBUILDER\Composite_MOD_FILENAME.txt
del /f /q MODBUILDER\CurrentModScript.txt
del /f /q MODBUILDER\input.txt
del /f /q MODBUILDER\MASTER_FOLDER_PATH.txt
del /f /q MODBUILDER\MBIN_PAKS.txt
del /f /q MODBUILDER\MBINCompiler.log
del /f /q MODBUILDER\MOD_FILENAME.txt
del /f /q MODBUILDER\MOD_MBIN_SOURCE.txt
del /f /q MODBUILDER\MOD_PAK_SOURCE.txt
del /f /q MODBUILDER\MODS_pak_list.txt
del /f /q MODBUILDER\NMS_FOLDER.txt
del /f /q MODBUILDER\pak_listDateTime.txt
del /f /q MODBUILDER\Times.txt
REM ---- full clean up added by seekker
rem ****/seekker*****************************************************
rem *********************************************************

goto :eof
rem ---------- WE ARE DONE ---------------------

rem --------------------------------------------
rem subroutine section starts below
rem --------------------------------------------
:Cleaning_MOD
	if %_bCOMBINE_MODS% NEQ 0 (
		if !_bScriptCounter! EQU 1 goto :CLEAN_MOD2
		if !_bScriptCounter! GTR 1 goto :PREP
	)

	echo.^>^>^> %_bB% INDIVIDUAL MODs: Cleaning directory MOD each time
	goto :CLEAN_MOD

	:CLEAN_MOD2
	echo.^>^>^> %_bB% COMBINED MOD: Cleaning directory MOD before first script only

	:CLEAN_MOD
	Del /f /q /s "MOD\*.*" 1>NUL 2>NUL
	:RETRY2
	if exist "MOD" (
		rd /s /q "MOD" 2>NUL
		goto :RETRY2
	)
	mkdir "MOD"
	goto :PREPARATION

	:PREP
	echo.^>^>^> %_bB% COMBINED MOD: KEEPING files in directory MOD

	:PREPARATION
	EXIT /B

rem --------------------------------------------
:Cleaning_EXML_Helper
	Del /f /q /s "EXML_Helper\*.*" 1>NUL 2>NUL
	:RETRY4
	if exist "EXML_Helper" (
		rd /s /q "EXML_Helper" 2>NUL
		goto :RETRY4
	)
	mkdir "EXML_Helper"
	mkdir "EXML_Helper\MOD_EXML"
	mkdir "EXML_Helper\ORG_EXML"
	EXIT /B
	
rem --------------------------------------------
:Cleaning_TEMP
	Del /f /q /s "_TEMP\*.*" 1>NUL 2>NUL
	:RETRY5
	if exist "_TEMP" (
		rd /s /q "_TEMP" 2>NUL
		goto :RETRY5
	)
	rem DO NOT create _TEMP
	EXIT /B
	
rem --------------------------------------------
:Cleaning_EXTRACTED_PAK
	Del /f /q /s "EXTRACTED_PAK\*.*" 1>NUL 2>NUL
	:RETRY7
	if exist "EXTRACTED_PAK" (
		rd /s /q "EXTRACTED_PAK" 1>NUL 2>NUL
		goto :RETRY7
	)
	rem DO NOT create ModScript\EXTRACTED_PAK
	EXIT /B

rem --------------------------------------------
:Cleaning_EXMLFILES_PAK
	Del /f /q /s "EXMLFILES_PAK\*.*" 1>NUL 2>NUL
	:RETRY8
	if exist "EXMLFILES_PAK" (
		rd /s /q "EXMLFILES_PAK" 1>NUL 2>NUL
		goto :RETRY8
	)
	rem DO NOT create ModScript\EXMLFILES_PAK
	EXIT /B

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
	)
	EXIT /B
	
rem --------------------------------------------
:LuaEndedOkREMOVE
	Del /f /q /s "%_bMASTER_FOLDER_PATH%\MODBUILDER\LuaEndedOK.txt" 1>NUL 2>NUL
	EXIT /B
	
rem --------------------------------------------
