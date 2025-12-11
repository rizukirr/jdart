@echo off
REM Build script for jdart CLI tool on Windows

set VERSION=1.0.0
set OUTPUT_DIR=build\release

echo Building jdart v%VERSION%...
echo.

REM Create output directory
if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

REM Build for Windows
echo Building for Windows...
dart compile exe bin\jdart.dart -o "%OUTPUT_DIR%\jdart.exe"
echo. Built: %OUTPUT_DIR%\jdart.exe
echo.

echo Build complete! Executable available at: %OUTPUT_DIR%\jdart.exe
echo.
echo To use globally, add the following directory to your PATH:
echo   %CD%\%OUTPUT_DIR%
