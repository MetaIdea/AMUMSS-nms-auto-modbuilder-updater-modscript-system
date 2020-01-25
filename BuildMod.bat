REM echo off
setlocal EnableDelayedExpansion
set "args="
for /f "tokens=1,2 delims==" %%G in (options.txt) do (
    set "args=!args!-%%G %%~H "
)
Builder.bat %args%