@echo off
chcp 936 >nul 2>&1
echo ========================================
echo   CourtClaw - APK Build Script
echo ========================================
echo.

set JAVA_HOME=F:\packaging\jbr
set ANDROID_HOME=F:\apk
set FLUTTER_HOME=F:\flutter

echo [1/5] Checking environment...
if not exist "%JAVA_HOME%\bin\java.exe" (
    echo [ERROR] Java not found: %JAVA_HOME%
    goto :fail
)
if not exist "%ANDROID_HOME%\platform-tools\adb.exe" (
    echo [ERROR] Android SDK not found: %ANDROID_HOME%
    goto :fail
)
if not exist "%FLUTTER_HOME%\bin\flutter.bat" (
    echo [ERROR] Flutter SDK not found: %FLUTTER_HOME%
    goto :fail
)
echo [OK] Environment check passed
echo.

echo [2/5] Cleaning Gradle lock files...
for /d %%d in ("%USERPROFILE%\.gradle\wrapper\dists\*") do (
    if exist "%%d\*.lck" del /f /q "%%d\*.lck" >nul 2>&1
)
echo [OK] Lock files cleaned
echo.

cd /d "%~dp0mobile_app"
if errorlevel 1 (
    echo [ERROR] Cannot enter mobile_app directory
    goto :fail
)

echo [3/5] Running flutter pub get...
"%FLUTTER_HOME%\bin\flutter" pub get
if errorlevel 1 (
    echo [ERROR] flutter pub get failed
    goto :fail
)
echo [OK] Dependencies ready
echo.

echo [4/5] Building Release APK...
echo   This may take a few minutes, please wait...
echo.
"%FLUTTER_HOME%\bin\flutter" build apk --release --no-pub
if errorlevel 1 (
    echo.
    echo ========================================
    echo   BUILD FAILED!
    echo   Common fixes:
    echo   1. Network timeout -> retry this script
    echo   2. Low memory -> close other apps
    echo   3. JDK mismatch -> check JAVA_HOME
    echo ========================================
    goto :fail
)
echo.
echo [OK] Build SUCCESS!
echo.

echo [5/5] Output location:
echo   APK: %~dp0mobile_app\build\app\outputs\flutter-apk\app-release.apk
echo.
echo ========================================
echo   ALL DONE!
echo ========================================
pause
exit /b 0

:fail
echo.
echo Press any key to exit...
pause >nul
exit /b 1