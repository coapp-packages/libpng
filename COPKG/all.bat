@echo off
setlocal

if "%1"=="clean" goto :clean
if "%1"=="noclean" (
	set __NOCLEAN__=true
	shift)

nuget restore ..\projects\vstudio\vstudio.sln

setlocal
call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86
call :build Win32 Release v140
call :build Win32 Debug v140
call :build x64 Release v140
call :build x64 Debug v140
endlocal

setlocal
call "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat" x86
call :build Win32 Release v120
call :build Win32 Debug v120
call :build x64 Release v120
call :build x64 Debug v120
endlocal

cd ..
call :test Win32 Release v140
call :test Win32 Debug v140
call :test x64 Release v140
call :test x64 Debug v140
call :test Win32 Release v120
call :test Win32 Debug v120
call :test x64 Release v120
call :test x64 Debug v120
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
"projects\vstudio\%3\%1\%~2\pngstest.exe" --strict --log contrib/pngsuite/basn0g01.png contrib/pngsuite/basn0g02.png contrib/pngsuite/basn0g04.png contrib/pngsuite/basn0g08.png contrib/pngsuite/basn0g16.png contrib/pngsuite/basn2c08.png contrib/pngsuite/basn2c16.png contrib/pngsuite/basn3p01.png contrib/pngsuite/basn3p02.png contrib/pngsuite/basn3p04.png contrib/pngsuite/basn3p08.png contrib/pngsuite/basn4a08.png contrib/pngsuite/basn4a16.png contrib/pngsuite/basn6a08.png contrib/pngsuite/basn6a16.png contrib/pngsuite/ftbbn0g01.png contrib/pngsuite/ftbbn0g02.png contrib/pngsuite/ftbbn0g04.png contrib/pngsuite/ftbbn2c16.png contrib/pngsuite/ftbbn3p08.png contrib/pngsuite/ftbgn2c16.png contrib/pngsuite/ftbgn3p08.png contrib/pngsuite/ftbrn2c08.png contrib/pngsuite/ftbwn0g16.png contrib/pngsuite/ftbwn3p08.png contrib/pngsuite/ftbyn3p08.png contrib/pngsuite/ftp0n0g08.png contrib/pngsuite/ftp0n2c08.png contrib/pngsuite/ftp0n3p08.png contrib/pngsuite/ftp1n3p08.png || goto :failed
"projects\vstudio\%3\%1\%~2\pngunknown.exe" --strict --default pngtest.png || goto :failed
goto :eof
:failed
set __FAILED__=true
echo tests failed for %1 %2 %3
goto :eof

:clean
rd /s /q ..\projects\vstudio\libpng\v120
rd /s /q ..\projects\vstudio\pnglibconf\v120
rd /s /q ..\projects\vstudio\pngtest\v120
rd /s /q ..\projects\vstudio\pngvalid\v120
rd /s /q ..\projects\vstudio\libpng\v140
rd /s /q ..\projects\vstudio\pnglibconf\v140
rd /s /q ..\projects\vstudio\pngtest\v140
rd /s /q ..\projects\vstudio\pngvalid\v140

