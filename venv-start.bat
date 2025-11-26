@echo off
REM 红墨 venv 启动脚本 (Windows)
REM 使用方式: venv-start.bat [start|stop|logs|shell]

setlocal enabledelayedexpansion

REM 颜色定义（Windows 10+ 支持）
set "RESET=[0m"
set "RED=[91m"
set "GREEN=[92m"
set "YELLOW=[93m"
set "BLUE=[94m"
set "CYAN=[96m"

REM 定义日志文件
set "BACKEND_LOG=backend.log"
set "FRONTEND_LOG=frontend.log"
set "BACKEND_PID_FILE=.backend.pid"
set "FRONTEND_PID_FILE=.frontend.pid"

REM 打印标题
echo.
echo %BLUE%╔════════════════════════════════════╗%RESET%
echo %BLUE%║    红墨 AI图文生成器 - venv 启动    ║%RESET%
echo %BLUE%╚════════════════════════════════════╝%RESET%
echo.

REM 处理命令
if "%1"=="" goto help
if /i "%1"=="start" goto start_services
if /i "%1"=="stop" goto stop_services
if /i "%1"=="setup" goto setup_environment
if /i "%1"=="logs" goto view_logs
if /i "%1"=="status" goto show_status
if /i "%1"=="shell" goto enter_shell
if /i "%1"=="help" goto help
if /i "%1"=="/?" goto help

echo %RED%✗ 未知命令: %1%RESET%
goto help

:start_services
echo %BLUE%🚀 启动服务...%RESET%
echo.

REM 检查虚拟环境
if not exist "venv" (
    echo %YELLOW%📦 创建虚拟环境...%RESET%
    python -m venv venv
    if errorlevel 1 (
        echo %RED%✗ 虚拟环境创建失败%RESET%
        exit /b 1
    )
)

REM 激活虚拟环境
call venv\Scripts\activate.bat

REM 检查依赖
if not exist "frontend\node_modules" (
    echo %YELLOW%📦 安装依赖...%RESET%
    cd frontend
    call pnpm install
    cd ..
)

REM 检查配置文件
if not exist "text_providers.yaml" (
    echo %YELLOW%📝 创建文本生成配置...%RESET%
    copy text_providers.yaml.example text_providers.yaml
    echo %YELLOW%⚠ 请编辑 text_providers.yaml 填入你的 API Key%RESET%
)

if not exist "image_providers.yaml" (
    echo %YELLOW%📝 创建图片生成配置...%RESET%
    copy image_providers.yaml.example image_providers.yaml
    echo %YELLOW%⚠ 请编辑 image_providers.yaml 填入你的 API Key%RESET%
)

REM 创建必要目录
if not exist "output" mkdir output
if not exist "history" mkdir history

echo.
echo %BLUE%════════════════════════════════════%RESET%
echo %GREEN%✓ 启动中...（按任意键继续）%RESET%
echo %BLUE%════════════════════════════════════%RESET%
echo.

REM 启动后端
echo %BLUE%🚀 启动后端 (http://localhost:12398)...%RESET%
start "红墨后端" /B python -m backend.app
timeout /t 2 /nobreak

REM 启动前端
echo %BLUE%🚀 启动前端 (http://localhost:5173)...%RESET%
cd frontend
start "红墨前端" cmd /K "pnpm dev"
cd ..

echo.
echo %GREEN%✓ 所有服务启动成功！%RESET%
echo.
echo %CYAN%📱 访问地址:%RESET%
echo   前端: http://localhost:5173
echo   后端 API: http://localhost:12398
echo.
pause
goto :eof

:stop_services
echo %YELLOW%🛑 停止服务...%RESET%
echo.
taskkill /F /IM python.exe /T 2>nul
taskkill /F /IM node.exe /T 2>nul
echo %GREEN%✓ 所有服务已停止%RESET%
echo.
pause
goto :eof

:setup_environment
echo %YELLOW%🔍 环境检查和设置...%RESET%
echo.

REM 检查 Python
python --version >nul 2>&1
if errorlevel 1 (
    echo %RED%✗ Python 未安装%RESET%
    exit /b 1
)
echo %GREEN%✓ Python 已安装%RESET%

REM 检查 Node.js
node --version >nul 2>&1
if errorlevel 1 (
    echo %RED%✗ Node.js 未安装%RESET%
    exit /b 1
)
echo %GREEN%✓ Node.js 已安装%RESET%

REM 检查 pnpm
pnpm --version >nul 2>&1
if errorlevel 1 (
    echo %RED%✗ pnpm 未安装，正在安装...%RESET%
    npm install -g pnpm
)
echo %GREEN%✓ pnpm 已安装%RESET%

REM 创建虚拟环境
if not exist "venv" (
    echo %YELLOW%📦 创建虚拟环境...%RESET%
    python -m venv venv
    echo %GREEN%✓ 虚拟环境已创建%RESET%
)

REM 激活虚拟环境
call venv\Scripts\activate.bat

REM 安装依赖
echo %YELLOW%📦 安装后端依赖...%RESET%
pip install --upgrade pip
pip install uv
uv sync
echo %GREEN%✓ 后端依赖已安装%RESET%

echo %YELLOW%📦 安装前端依赖...%RESET%
cd frontend
pnpm install
cd ..
echo %GREEN%✓ 前端依赖已安装%RESET%

REM 创建配置文件
copy text_providers.yaml.example text_providers.yaml
copy image_providers.yaml.example image_providers.yaml

REM 创建必要目录
if not exist "output" mkdir output
if not exist "history" mkdir history

echo.
echo %GREEN%✓ 环境设置完成！%RESET%
echo.
echo %CYAN%下一步: venv-start.bat start%RESET%
echo.
pause
goto :eof

:view_logs
echo %CYAN%📋 查看实时日志（按 Ctrl+C 停止）%RESET%
echo.
if exist "%BACKEND_LOG%" (
    type "%BACKEND_LOG%"
) else (
    echo %YELLOW%⚠ 后端日志不存在%RESET%
)
echo.
if exist "%FRONTEND_LOG%" (
    type "%FRONTEND_LOG%"
) else (
    echo %YELLOW%⚠ 前端日志不存在%RESET%
)
echo.
pause
goto :eof

:show_status
echo %CYAN%📊 服务状态%RESET%
echo.

tasklist /FI "IMAGENAME eq python.exe" 2>nul | find /I "python" >nul
if errorlevel 1 (
    echo 后端: %RED%✗ 未运行%RESET%
) else (
    echo 后端: %GREEN%✓ 运行中%RESET%
    echo   地址: http://localhost:12398
)

tasklist /FI "IMAGENAME eq node.exe" 2>nul | find /I "node" >nul
if errorlevel 1 (
    echo 前端: %RED%✗ 未运行%RESET%
) else (
    echo 前端: %GREEN%✓ 运行中%RESET%
    echo   地址: http://localhost:5173
)

echo.
echo %CYAN%配置文件:%RESET%
if exist "text_providers.yaml" (
    echo   text_providers.yaml: %GREEN%✓%RESET%
) else (
    echo   text_providers.yaml: %RED%✗%RESET%
)

if exist "image_providers.yaml" (
    echo   image_providers.yaml: %GREEN%✓%RESET%
) else (
    echo   image_providers.yaml: %RED%✗%RESET%
)

echo.
pause
goto :eof

:enter_shell
echo %CYAN%📂 进入虚拟环境（输入 'deactivate' 退出）%RESET%
echo.
call venv\Scripts\activate.bat
cmd
goto :eof

:help
echo %CYAN%使用方式:%RESET%
echo   venv-start.bat [命令]
echo.
echo %CYAN%可用命令:%RESET%
echo   start       启动所有服务
echo   stop        停止所有服务
echo   setup       首次运行环境设置
echo   logs        查看日志
echo   status      查看服务状态
echo   shell       进入虚拟环境
echo   help        显示此帮助信息
echo.
echo %CYAN%示例:%RESET%
echo   venv-start.bat start
echo   venv-start.bat logs
echo   venv-start.bat stop
echo.
pause
goto :eof
