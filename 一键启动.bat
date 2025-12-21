@echo off
chcp 65001 > nul
cd /d "%~dp0"
title 企鹅艾洛魔法世界
color 0B

echo.
echo  ============================================
echo       企鹅艾洛魔法世界 - 启动中...
echo  ============================================
echo.

:: Check Environment
echo  [CHECK] 检查环境...

where node >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo.
    echo  [ERROR] 未找到 Node.js！
    echo          请运行 "首次安装.bat" 或安装 Node.js
    echo.
    pause
    exit /b 1
)
echo  [OK] Node.js 就绪

:: Check node_modules
if not exist "backend-nodejs\node_modules" (
    color 0E
    echo.
    echo  [WARN] 后端依赖未安装，请先运行 "首次安装.bat"
    echo.
    pause
    exit /b 1
)

if not exist "dist" (
    color 0E
    echo.
    echo  [WARN] 前端未构建，请先运行 "首次安装.bat"
    echo.
    pause
    exit /b 1
)
echo  [OK] 依赖就绪
echo.

:: Kill existing services
echo  [CLEAN] 清理旧服务...
for /f "tokens=5" %%a in ('netstat -ano 2^>nul ^| findstr ":8765 " ^| findstr "LISTENING"') do (
    taskkill /f /pid %%a >nul 2>&1
)
echo  [OK] 端口已清理
echo.

:: Create directories
if not exist "data" mkdir "data"
if not exist "input" mkdir "input"
if not exist "output" mkdir "output"
if not exist "creative_images" mkdir "creative_images"

:: Start backend
echo  [START] 启动 Node.js 后端服务...
start "企鹅魔法-后端" cmd /c "cd /d "%~dp0backend-nodejs" && node src/server.js || (echo 后端启动失败 && pause)"

:: Wait for backend
echo        等待后端启动...
ping 127.0.0.1 -n 4 > nul

:: Check backend
netstat -ano | findstr ":8765" | findstr "LISTENING" >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo.
    echo  [ERROR] 后端启动失败！
    echo          请检查后端窗口的错误信息
    echo.
    pause
    exit /b 1
)
echo  [OK] 后端运行中 (8765)
echo.

:: Open browser
color 0A
echo  [SUCCESS] 打开浏览器...
start http://127.0.0.1:8765

echo.
echo  ============================================
echo.
echo   服务正在后台运行
echo   可以关闭此窗口
 echo.
echo   访问地址: http://127.0.0.1:8765
echo.
echo   要停止服务: 运行 "停止服务.bat"
echo.
echo  ============================================
echo.

timeout /t 5 > nul
