@echo off
setlocal EnableDelayedExpansion
set "args="
set "rootPath=%~dp0"
set "optionsFile=!rootPath!\OPTIONS.yaml"

if not exist %optionsFile% (
    echo # These are the default options used by BuildMod.bat to build your mods.>%optionsFile%
    echo # In each one of them you can either specify a default value or put 'ask'.>> %optionsFile%
    echo # Any option with a value of ask will result in the builder to ask you the question during the build process.>> %optionsFile%
    echo.>>%optionsFile%
    echo # Possible Values:>> %optionsFile%
    echo # combine = ask, none, simple, composite, numericSuffix>> %optionsFile%
    echo # copy =  ask, none, all, some>> %optionsFile%
    echo.>>%optionsFile%
    echo # All the other options are flags with possible values of: ask, true, false>> %optionsFile%
    echo.>>%optionsFile%
    echo combine: ask>> %optionsFile%
    echo copy: ask>> %optionsFile%
    echo includeExtraFiles: ask>> %optionsFile%
    echo rebuildMod: ask>> %optionsFile%
    echo updateMBINCompiler: ask>> %optionsFile%
    echo checkForConflicts: ask>> %optionsFile%
    echo recreatePakList: ask>> %optionsFile%
    echo|set /p="recreateMapFileTrees: ask">> %optionsFile%
)

rem The added space character in `delims=: ` is to support same line comments in the yaml file. 
rem As a side effect typing `key value` instead of `key: value` would also work.
rem If we decide to just not support same line comments we should change it to `delims=:`
for /f "tokens=1,2 eol=# delims=: " %%G in (%optionsFile%) do (    
    set "args=!args!-%%G %%~H "
)
!rootPath!\MODBUILDER\Builder.bat %args%
