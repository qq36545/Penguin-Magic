@echo off
chcp 65001 > nul
cd /d "%~dp0"

echo.
echo  企鹅艾洛魔法世界 - 停止服务
echo.

:: Stop backend
echo  停止后端服务 (端口 8765)...
for /f "tokens=5" %%a in ('netstat -ano 2^>nul ^| findstr ":8765 " ^| findstr "LISTENING"') do (
    taskkill /f /pid %%a >nul 2>&1
    echo  [OK] 已停止 PID: %%a
)

:: Close related cmd windows
taskkill /f /fi "WINDOWTITLE eq 企鹅魔法-后端" >nul 2>&1

echo.
echo  [OK] 所有服务已停止！
echo.
timeout /t 3 > nul
