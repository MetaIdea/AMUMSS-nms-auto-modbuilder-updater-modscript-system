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


setlocal EnableDelayedExpansion
for /r %%B in (*.pak) do (
	for /F "tokens=*" %%A in (..\MOD_MBIN_SOURCE.txt) do (
		psarc.exe extract "%%B" %%A --to="%cd%\EXTRACTED" -y
	)
)
)
endlocal 

setlocal EnableDelayedExpansion
for /F "tokens=*" %%A in (..\MOD_MBIN_SOURCE.txt) do (
	MBINCompiler.exe "%cd%\EXTRACTED\%%A" -y -f -d "%cd%\DECOMPILED\%%A\.."
	REM for /r %%a in (*.MBIN) do MBINCompiler.exe "%%a" -y -f -d "%cd%\DECOMPILED"
	set MBIN_FILE=%%A
	set EXML_FILE=!MBIN_FILE:.MBIN=.EXML!
	if NOT %COMBINE_MODS% EQU 0 (
		@ECHO N|xcopy /-Y /h /v /i "%cd%\DECOMPILED\!EXML_FILE!" "..\MOD\%%A\..\" 
		rem xcopy /y /h /v /i "%cd%\DECOMPILED\!EXML_FILE!" "..\MOD\%%A\..\" 
	) ELSE (
		xcopy /y /h /v /i "%cd%\DECOMPILED\!EXML_FILE!" "..\MOD\%%A\..\" 
	)
)
endlocal 

cd ..
rmdir /s /q "%CD%\_TEMP"


