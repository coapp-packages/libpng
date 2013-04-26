@echo off
setlocal

if "%1"=="clean" goto :clean
if "%1"=="noclean" (
	set __NOCLEAN__=true
	shift)

setlocal
call "C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat" x86
call :build Win32 Release v110
call :build Win32 Debug v110
call :build x64 Release v110
call :build x64 Debug v110
call :build Win32 "Release Library" v110
call :build Win32 "Debug Library" v110
call :build x64 "Release Library" v110
call :build x64 "Debug Library" v110
endlocal

setlocal
call "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat" x86
call :build Win32 Release v100
call :build Win32 Debug v100
call :build x64 Release v100
call :build x64 Debug v100
call :build Win32 "Release Library" v100
call :build Win32 "Debug Library" v100
call :build x64 "Release Library" v100
call :build x64 "Debug Library" v100
endlocal

cd ..
call :test Win32 Release v110
call :test Win32 Debug v110
call :test x64 Release v110
call :test x64 Debug v110
call :test Win32 Release v100
call :test Win32 Debug v100
call :test x64 Release v100
call :test x64 Debug v100
call :test Win32 "Release Library" v110
call :test Win32 "Debug Library" v110
call :test x64 "Release Library" v110
call :test x64 "Debug Library" v110
call :test Win32 "Release Library" v100
call :test Win32 "Debug Library" v100
call :test x64 "Release Library" v100
call :test x64 "Debug Library" v100
cd COPKG

if "__NOCLEAN__"=="true" goto :eof

goto :clean

:build
msbuild /P:Platform=%1 /P:Configuration=%2 /P:PlatformToolset=%3 ..\projects\vstudio\vstudio.sln
goto :eof

:test
if "__FAILED__"=="true" goto eof
"projects\vstudio\%3\%1\%~2\pngtest.exe" || goto :failed
"projects\vstudio\%3\%1\%~2\pngvalid.exe" || goto :failed
goto :eof
:failed
set __FAILED__=true
echo tests failed for %1 %2 %3
goto :eof

:clean
rd /s /q ..\projects\vstudio\libpng\v100
rd /s /q ..\projects\vstudio\pnglibconf\v100
rd /s /q ..\projects\vstudio\pngtest\v100
rd /s /q ..\projects\vstudio\pngvalid\v100
rd /s /q ..\projects\vstudio\libpng\v110
rd /s /q ..\projects\vstudio\pnglibconf\v110
rd /s /q ..\projects\vstudio\pngtest\v110
rd /s /q ..\projects\vstudio\pngvalid\v110

