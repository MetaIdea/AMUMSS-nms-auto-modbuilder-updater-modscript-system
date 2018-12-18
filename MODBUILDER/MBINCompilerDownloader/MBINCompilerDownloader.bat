@echo off
curl -s "https://github.com/monkeyman192/MBINCompiler/releases" > temp.txt
set /p RAW=<temp.txt
lua4.exe ExtractLink.lua
set /p URL=<temp.txt
curl -LO %URL%
xcopy /y /h /v "%CD%\MBINCompiler.exe" "%CD%\..\"
pause