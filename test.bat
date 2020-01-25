@echo off
setlocal EnableDelayedExpansion

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
set -
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
set _arg