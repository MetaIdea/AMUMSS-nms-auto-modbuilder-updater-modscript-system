set /p NMS_FOLDER=<NMS_FOLDER.txt
set NMS_PCBANKS_FOLDER=%NMS_FOLDER%\GAMEDATA\PCBANKS\
set /p MOD_PAK_SOURCE=<MOD_PAK_SOURCE.txt
set /p MOD_MBIN_SOURCE=<MOD_MBIN_SOURCE.txt
if not exist "%CD%\_TEMP" mkdir "%CD%\_TEMP\"
xcopy /y /h /v "psarc.exe" "%CD%\_TEMP\"
xcopy /y /h /v "MBINCompiler.exe" "%CD%\_TEMP\"
cd _TEMP
for /F "tokens=*" %%A in (..\MOD_PAK_SOURCE.txt) do (
	xcopy /s /i /y /h /v "%NMS_PCBANKS_FOLDER%%%A" "%CD%\PAK_SOURCES\"
)
for /r %%a in (*.pak) do psarc.exe extract "%%a" --to="%cd%\EXTRACTED" -y

setlocal EnableDelayedExpansion
for /F "tokens=*" %%A in (..\MOD_MBIN_SOURCE.txt) do (
	MBINCompiler.exe "%cd%\EXTRACTED\%%A" -y -f -d "%cd%\DECOMPILED\%%A\.."
	REM for /r %%a in (*.MBIN) do MBINCompiler.exe "%%a" -y -f -d "%cd%\DECOMPILED"
	set MBIN_FILE=%%A
	set EXML_FILE=!MBIN_FILE:.MBIN=.EXML!
	xcopy /y /h /v /i "%cd%\DECOMPILED\!EXML_FILE!" "..\MOD\%%A\..\"
)

cd ..
rmdir /s /q "%CD%\_TEMP"

