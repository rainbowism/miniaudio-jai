@echo off

if not exist "..\win" mkdir ..\win

cl -nologo -MT -TC -O2 -c miniaudio.c
lib -nologo miniaudio.obj -out:..\win\miniaudio.lib

del *.obj
