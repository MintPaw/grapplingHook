@echo off
:start
cd "%~dp0\.."
echo win32 build system
echo 1. reset/pull
echo 2. build/run cpp
echo 3. build/run flash
echo 4. quit
set /p opt=Pick: 

echo.
echo Working...

if %opt%==1 (
	git reset --hard
	git pull --recurse-submodules
)

if %opt%==2 (
	del bin\Windows\cpp\bin\*.exe /f /s /q
	openfl build windows -debug -verbose
	cd bin\Windows\cpp\bin
	.\GrapplingHook.exe
	cd ..\..\..\..\
)

if %opt%==3 (
	del bin\flash\bin\*.swf /f /s /q
	openfl build flash -debug
	echo ^<center^>^<embed src="GrapplingHook.swf" width="1280" height="720" /^>^</center^> >> bin\flash\bin\index.html
	.\bin\flash\bin\index.html
)

if %opt%==4 ( exit )

goto start
