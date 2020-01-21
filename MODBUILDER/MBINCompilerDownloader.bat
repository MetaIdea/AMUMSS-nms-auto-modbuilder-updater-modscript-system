@echo off
echo.^>^>^>     In MBINCompilerDownloader.bat
cd MBINCompilerDownloader
curl -s "https://github.com/monkeyman192/MBINCompiler/releases" > temp.txt
set /p RAW=<temp.txt
%_mLUA% ExtractLink.lua
set /p URL=<temp.txt
curl -LO %URL%
xcopy /y /h /v "%CD%\MBINCompiler.exe" "%CD%\..\" 1>nul 2>nul
cd ..
