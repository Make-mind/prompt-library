@echo off
cd /d "%~dp0"
echo 🚀 启动提示词库...
echo 服务地址：http://localhost:8765
echo 按 Ctrl+C 或关闭窗口停止服务
echo.
echo 正在启动服务器...

REM 先启动服务器（新窗口），等两秒，再开浏览器
start "" python -m http.server 8765
timeout /t 3 /nobreak >nul
start http://localhost:8765

echo ✅ 已启动
pause
