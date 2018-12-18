@echo on
cd ..\ModScript

for /r %%M in (*.lua) do (
..\MODBUILDER\luac4.exe %%M
)
pause