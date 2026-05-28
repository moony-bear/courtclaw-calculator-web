@echo off
chcp 65001 >nul
echo ========================================
echo   CourtClaw 利息计算器 - APK 打包脚本
echo ========================================
echo.

set JAVA_HOME=F:\packaging\jbr
set ANDROID_HOME=F:\apk

echo [1/5] 检查环境...
if not exist "%JAVA_HOME%\bin\java.exe" (
    echo 错误: 找不到 Java (%JAVA_HOME%)
    pause
    exit /b 1
)
if not exist "%ANDROID_HOME%\platform-tools\adb.exe" (
    echo 错误: 找不到 Android SDK (%ANDROID_HOME%)
    pause
    exit /b 1
)
if not exist "F:\flutter\bin\flutter.bat" (
    echo 错误: 找不到 Flutter SDK (F:\flutter)
    pause
    exit /b 1
)

echo [2/5] 清理 Gradle 缓存锁文件（解决超时问题）...
for /d %%d in ("%USERPROFILE%\.gradle\wrapper\dists\*") do (
    if exist "%%d\*.lck" del /f /q "%%d\*.lck" >nul 2>&1
)
if not exist "%USERPROFILE%\.gradle\wrapper\dists\gradle-9.1.0-all\gradle-9.1.0" (
    echo   注意：Gradle 9.1.0 首次下载可能需要较长时间...
    echo   如果超时，请确保网络通畅后重试
)
echo ✓ 环境检查通过
echo.

cd /d "%~dp0mobile_app"

echo [3/5] 获取项目依赖...
F:\flutter\bin\flutter pub get
if errorlevel 1 (
    echo 错误: 获取依赖失败
    pause
    exit /b 1
)
echo ✓ 依赖获取完成
echo.

echo [4/5] 构建 Release APK...
echo 这可能需要几分钟时间，请耐心等待...
echo.
F:\flutter\bin\flutter build apk --release --no-pub
if errorlevel 1 (
    echo.
    echo ========================================
    echo   构建失败！常见原因：
    echo   1. Gradle 下载超时 → 重试此脚本
    echo   2. 内存不足 → 关闭其他程序后重试
    echo   3. JDK 版本不匹配 → 检查 JAVA_HOME
    echo ========================================
    pause
    exit /b 1
)
echo.
echo ✓ 构建成功！
echo.

echo [5/5] 输出文件位置:
echo.
echo   APK 文件: %~dp0mobile_app\build\app\outputs\flutter-apk\app-release.apk
echo.
echo ========================================
echo   打包完成！
echo ========================================
pause