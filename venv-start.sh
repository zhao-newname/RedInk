#!/bin/bash

# 红墨 venv 启动脚本
# 使用方式: bash venv-start.sh [start|stop|logs|shell]

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 获取脚本所在目录
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# 定义日志文件
BACKEND_LOG="backend.log"
FRONTEND_LOG="frontend.log"
BACKEND_PID_FILE=".backend.pid"
FRONTEND_PID_FILE=".frontend.pid"

# 打印标题
print_header() {
    echo -e "\n${BLUE}╔════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║    红墨 AI图文生成器 - venv 启动    ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════╝${NC}\n"
}

# 打印帮助信息
print_help() {
    cat << EOF
${CYAN}使用方式:${NC}
  bash venv-start.sh [命令]

${CYAN}可用命令:${NC}
  start       启动所有服务（后台运行）
  stop        停止所有服务
  restart     重启所有服务
  logs        查看实时日志
  backend-log 查看后端日志
  frontend-log 查看前端日志
  shell       进入虚拟环境 shell
  status      查看服务状态
  setup       首次运行环境检查和依赖安装
  clean       清理日志和 PID 文件
  help        显示此帮助信息

${CYAN}示例:${NC}
  bash venv-start.sh start      # 启动服务
  bash venv-start.sh logs       # 查看日志
  bash venv-start.sh stop       # 停止服务

EOF
}

# 环境检查
check_environment() {
    local missing=0

    echo -e "${YELLOW}🔍 环境检查...${NC}"
    
    # 检查 Python
    if ! command -v python3 &> /dev/null; then
        echo -e "${RED}✗ Python 3 未安装${NC}"
        missing=1
    else
        PY_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
        echo -e "${GREEN}✓ Python: $PY_VERSION${NC}"
    fi

    # 检查 Node.js
    if ! command -v node &> /dev/null; then
        echo -e "${RED}✗ Node.js 未安装${NC}"
        missing=1
    else
        NODE_VERSION=$(node --version)
        echo -e "${GREEN}✓ Node.js: $NODE_VERSION${NC}"
    fi

    # 检查 pnpm
    if ! command -v pnpm &> /dev/null; then
        echo -e "${RED}✗ pnpm 未安装${NC}"
        missing=1
    else
        PNPM_VERSION=$(pnpm --version)
        echo -e "${GREEN}✓ pnpm: $PNPM_VERSION${NC}"
    fi

    # 检查 uv
    if ! command -v uv &> /dev/null; then
        echo -e "${RED}✗ uv 未安装${NC}"
        missing=1
    else
        UV_VERSION=$(uv --version)
        echo -e "${GREEN}✓ uv: $UV_VERSION${NC}"
    fi

    if [ $missing -eq 1 ]; then
        echo -e "\n${RED}✗ 缺少必要的依赖！${NC}"
        echo -e "${YELLOW}请先安装缺失的工具，然后重试。${NC}"
        return 1
    fi

    echo -e "${GREEN}✓ 环境检查通过！${NC}\n"
    return 0
}

# 设置环境
setup_environment() {
    print_header
    
    if ! check_environment; then
        return 1
    fi

    # 检查虚拟环境
    if [ ! -d "venv" ]; then
        echo -e "${YELLOW}📦 创建虚拟环境...${NC}"
        python3 -m venv venv
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ 虚拟环境创建成功${NC}\n"
        else
            echo -e "${RED}✗ 虚拟环境创建失败${NC}"
            return 1
        fi
    fi

    # 激活虚拟环境
    source venv/bin/activate

    # 安装后端依赖
    echo -e "${YELLOW}📦 安装后端依赖...${NC}"
    if uv sync; then
        echo -e "${GREEN}✓ 后端依赖安装成功${NC}\n"
    else
        echo -e "${RED}✗ 后端依赖安装失败${NC}"
        return 1
    fi

    # 安装前端依赖
    if [ ! -d "frontend/node_modules" ]; then
        echo -e "${YELLOW}📦 安装前端依赖...${NC}"
        cd frontend
        if pnpm install; then
            echo -e "${GREEN}✓ 前端依赖安装成功${NC}\n"
        else
            echo -e "${RED}✗ 前端依赖安装失败${NC}"
            return 1
        fi
        cd ..
    fi

    # 检查和创建配置文件
    if [ ! -f "text_providers.yaml" ]; then
        echo -e "${YELLOW}📝 创建文本生成配置...${NC}"
        cp text_providers.yaml.example text_providers.yaml
        echo -e "${YELLOW}⚠ 请编辑 text_providers.yaml 填入你的 API Key${NC}\n"
    fi

    if [ ! -f "image_providers.yaml" ]; then
        echo -e "${YELLOW}📝 创建图片生成配置...${NC}"
        cp image_providers.yaml.example image_providers.yaml
        echo -e "${YELLOW}⚠ 请编辑 image_providers.yaml 填入你的 API Key${NC}\n"
    fi

    # 创建必要目录
    mkdir -p output history

    echo -e "${GREEN}✓ 环境设置完成！${NC}"
    echo -e "${CYAN}下一步: bash venv-start.sh start${NC}\n"
}

# 检查进程是否运行
is_running() {
    local pid_file=$1
    
    if [ -f "$pid_file" ]; then
        local pid=$(cat "$pid_file")
        if kill -0 "$pid" 2>/dev/null; then
            echo $pid
            return 0
        fi
    fi
    return 1
}

# 启动服务
start_services() {
    print_header
    
    if ! check_environment; then
        return 1
    fi

    # 激活虚拟环境
    source venv/bin/activate

    # 检查配置文件
    if [ ! -f "text_providers.yaml" ] || [ ! -f "image_providers.yaml" ]; then
        echo -e "${RED}✗ 配置文件不完整${NC}"
        echo -e "${YELLOW}请运行: bash venv-start.sh setup${NC}"
        return 1
    fi

    # 创建必要目录
    mkdir -p output history

    # 检查后端是否已运行
    if BACKEND_PID=$(is_running "$BACKEND_PID_FILE"); then
        echo -e "${YELLOW}⚠ 后端已在运行 (PID: $BACKEND_PID)${NC}"
    else
        echo -e "${BLUE}🚀 启动后端服务...${NC}"
        nohup uv run python -m backend.app > "$BACKEND_LOG" 2>&1 &
        BACKEND_PID=$!
        echo "$BACKEND_PID" > "$BACKEND_PID_FILE"
        sleep 2
        if kill -0 "$BACKEND_PID" 2>/dev/null; then
            echo -e "${GREEN}✓ 后端已启动 (PID: $BACKEND_PID)${NC}"
        else
            echo -e "${RED}✗ 后端启动失败${NC}"
            echo -e "${YELLOW}查看日志: tail -f $BACKEND_LOG${NC}"
            return 1
        fi
    fi

    # 检查前端是否已运行
    if FRONTEND_PID=$(is_running "$FRONTEND_PID_FILE"); then
        echo -e "${YELLOW}⚠ 前端已在运行 (PID: $FRONTEND_PID)${NC}"
    else
        echo -e "${BLUE}🚀 启动前端服务...${NC}"
        cd frontend
        nohup pnpm dev > "../$FRONTEND_LOG" 2>&1 &
        FRONTEND_PID=$!
        echo "$FRONTEND_PID" > "../$FRONTEND_PID_FILE"
        cd ..
        sleep 2
        if kill -0 "$FRONTEND_PID" 2>/dev/null; then
            echo -e "${GREEN}✓ 前端已启动 (PID: $FRONTEND_PID)${NC}"
        else
            echo -e "${RED}✗ 前端启动失败${NC}"
            echo -e "${YELLOW}查看日志: tail -f $FRONTEND_LOG${NC}"
            return 1
        fi
    fi

    echo -e "\n${BLUE}╔════════════════════════════════════╗${NC}"
    echo -e "${GREEN}✓ 所有服务启动成功！${NC}"
    echo -e "${BLUE}╚════════════════════════════════════╝${NC}\n"

    echo -e "${CYAN}📱 访问地址:${NC}"
    echo -e "  前端: ${GREEN}http://localhost:5173${NC}"
    echo -e "  后端 API: ${GREEN}http://localhost:12398${NC}\n"

    echo -e "${CYAN}📋 常用命令:${NC}"
    echo -e "  查看日志: bash venv-start.sh logs"
    echo -e "  查看状态: bash venv-start.sh status"
    echo -e "  停止服务: bash venv-start.sh stop"
    echo -e "  进入 Shell: bash venv-start.sh shell\n"
}

# 停止服务
stop_services() {
    print_header
    echo -e "${YELLOW}🛑 停止服务...${NC}\n"

    local stopped=0

    # 停止后端
    if BACKEND_PID=$(is_running "$BACKEND_PID_FILE"); then
        kill "$BACKEND_PID" 2>/dev/null
        sleep 1
        if ! kill -0 "$BACKEND_PID" 2>/dev/null; then
            echo -e "${GREEN}✓ 后端已停止 (PID: $BACKEND_PID)${NC}"
            rm -f "$BACKEND_PID_FILE"
            stopped=$((stopped + 1))
        else
            kill -9 "$BACKEND_PID" 2>/dev/null
            echo -e "${GREEN}✓ 后端已强制停止 (PID: $BACKEND_PID)${NC}"
            rm -f "$BACKEND_PID_FILE"
            stopped=$((stopped + 1))
        fi
    else
        echo -e "${YELLOW}ℹ 后端未运行${NC}"
    fi

    # 停止前端
    if FRONTEND_PID=$(is_running "$FRONTEND_PID_FILE"); then
        kill "$FRONTEND_PID" 2>/dev/null
        sleep 1
        if ! kill -0 "$FRONTEND_PID" 2>/dev/null; then
            echo -e "${GREEN}✓ 前端已停止 (PID: $FRONTEND_PID)${NC}"
            rm -f "$FRONTEND_PID_FILE"
            stopped=$((stopped + 1))
        else
            kill -9 "$FRONTEND_PID" 2>/dev/null
            echo -e "${GREEN}✓ 前端已强制停止 (PID: $FRONTEND_PID)${NC}"
            rm -f "$FRONTEND_PID_FILE"
            stopped=$((stopped + 1))
        fi
    else
        echo -e "${YELLOW}ℹ 前端未运行${NC}"
    fi

    if [ $stopped -gt 0 ]; then
        echo -e "\n${GREEN}✓ 所有服务已停止${NC}\n"
    else
        echo -e "\n${YELLOW}ℹ 没有运行的服务${NC}\n"
    fi
}

# 重启服务
restart_services() {
    stop_services
    sleep 2
    start_services
}

# 查看日志
view_logs() {
    print_header
    echo -e "${CYAN}📋 同时显示后端和前端日志${NC}"
    echo -e "${CYAN}按 Ctrl+C 停止查看${NC}\n"
    
    # 在后台启动 tail 命令
    tail -f "$BACKEND_LOG" "$FRONTEND_LOG" 2>/dev/null
}

# 查看后端日志
view_backend_logs() {
    if [ ! -f "$BACKEND_LOG" ]; then
        echo -e "${YELLOW}⚠ 后端日志不存在${NC}"
        return
    fi
    tail -f "$BACKEND_LOG"
}

# 查看前端日志
view_frontend_logs() {
    if [ ! -f "$FRONTEND_LOG" ]; then
        echo -e "${YELLOW}⚠ 前端日志不存在${NC}"
        return
    fi
    tail -f "$FRONTEND_LOG"
}

# 进入虚拟环境 shell
enter_shell() {
    print_header
    echo -e "${CYAN}📂 进入虚拟环境（输入 'exit' 或 'deactivate' 退出）${NC}\n"
    
    if [ ! -d "venv" ]; then
        echo -e "${RED}✗ 虚拟环境不存在${NC}"
        return 1
    fi
    
    source venv/bin/activate
    bash
}

# 查看服务状态
show_status() {
    print_header
    echo -e "${CYAN}📊 服务状态${NC}\n"

    # 后端状态
    if BACKEND_PID=$(is_running "$BACKEND_PID_FILE"); then
        echo -e "后端: ${GREEN}✓ 运行中${NC} (PID: $BACKEND_PID)"
        echo -e "  地址: http://localhost:12398"
    else
        echo -e "后端: ${RED}✗ 未运行${NC}"
    fi

    # 前端状态
    if FRONTEND_PID=$(is_running "$FRONTEND_PID_FILE"); then
        echo -e "前端: ${GREEN}✓ 运行中${NC} (PID: $FRONTEND_PID)"
        echo -e "  地址: http://localhost:5173"
    else
        echo -e "前端: ${RED}✗ 未运行${NC}"
    fi

    # 配置文件状态
    echo -e "\n${CYAN}配置文件:${NC}"
    [ -f "text_providers.yaml" ] && echo -e "  text_providers.yaml: ${GREEN}✓${NC}" || echo -e "  text_providers.yaml: ${RED}✗${NC}"
    [ -f "image_providers.yaml" ] && echo -e "  image_providers.yaml: ${GREEN}✓${NC}" || echo -e "  image_providers.yaml: ${RED}✗${NC}"

    # 虚拟环境
    echo -e "\n${CYAN}虚拟环境:${NC}"
    [ -d "venv" ] && echo -e "  venv: ${GREEN}✓ 存在${NC}" || echo -e "  venv: ${RED}✗ 不存在${NC}"

    # 依赖
    echo -e "\n${CYAN}依赖:${NC}"
    if [ -d "venv" ] && [ -d "frontend/node_modules" ]; then
        echo -e "  后端依赖: ${GREEN}✓ 已安装${NC}"
        echo -e "  前端依赖: ${GREEN}✓ 已安装${NC}"
    else
        echo -e "  后端依赖: ${YELLOW}? 未检测${NC}"
        echo -e "  前端依赖: ${YELLOW}? 未检测${NC}"
    fi

    echo ""
}

# 清理文件
clean_files() {
    print_header
    echo -e "${YELLOW}🧹 清理日志和 PID 文件...${NC}\n"

    rm -f "$BACKEND_LOG" "$FRONTEND_LOG" "$BACKEND_PID_FILE" "$FRONTEND_PID_FILE"
    echo -e "${GREEN}✓ 清理完成${NC}\n"
}

# 主程序
main() {
    local cmd="${1:-help}"

    case "$cmd" in
        start)
            start_services
            ;;
        stop)
            stop_services
            ;;
        restart)
            restart_services
            ;;
        logs)
            view_logs
            ;;
        backend-log)
            view_backend_logs
            ;;
        frontend-log)
            view_frontend_logs
            ;;
        shell)
            enter_shell
            ;;
        status)
            show_status
            ;;
        setup)
            setup_environment
            ;;
        clean)
            clean_files
            ;;
        help|--help|-h)
            print_header
            print_help
            ;;
        *)
            echo -e "${RED}✗ 未知命令: $cmd${NC}\n"
            print_help
            exit 1
            ;;
    esac
}

# 执行主程序
main "$@"
