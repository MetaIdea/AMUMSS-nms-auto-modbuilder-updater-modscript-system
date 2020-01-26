@echo off
setlocal EnableDelayedExpansion
set "args="
if not exist options.txt (    
    echo includeExtraFiles=ask> OPTIONS.txt
    echo rebuildMod=ask>> options.txt
    echo combine=ask>> options.txt
    echo copy=ask>> options.txt
    echo updateMBINCompiler=ask>> options.txt
    echo checkForConflicts=ask>> options.txt
    echo recreatePakList=ask>> options.txt
    echo|set /p="recreateMapFileTrees=ask">> options.txt
)
for /f "tokens=1,2 delims==" %%G in (options.txt) do (
    set "args=!args!-%%G %%~H "
)
Builder.bat %args%