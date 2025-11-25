#!/bin/bash

# ==============================================================================
# 小红书图文生成器 - Docker 快速启动脚本
# ==============================================================================
# 
# 使用方式:
#   bash docker-start.sh              # 交互式启动
#   bash docker-start.sh --help       # 显示帮助信息
#
# ==============================================================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置
PROJECT_NAME="xiaohongshu-generator"
DOCKER_PORT="${DOCKER_PORT:-12398}"
ENV_FILE=".env"
CONFIG_DIR="config"

# 帮助信息
show_help() {
    cat << EOF
${BLUE}小红书图文生成器 - Docker 快速启动脚本${NC}

用法:
  bash docker-start.sh [命令] [选项]

命令:
  start               启动应用（默认）
  stop                停止应用
  restart             重启应用
  rebuild             重新构建镜像并启动
  logs                查看实时日志
  clean               停止并清理所有容器和卷
  status              查看应用状态
  shell               进入容器 shell
  health              检查应用健康状态
  help                显示此帮助信息

选项:
  --port PORT         指定映射端口（默认: 12398）
  --env-file FILE     指定环境文件（默认: .env）
  -d, --detach        后台运行
  -f, --follow        跟随日志输出（用于 logs 命令）

示例:
  # 交互式启动
  bash docker-start.sh

  # 后台启动，并指定端口
  bash docker-start.sh start --port 8080 -d

  # 查看实时日志
  bash docker-start.sh logs -f

  # 重新构建并启动
  bash docker-start.sh rebuild -d

  # 进入容器
  bash docker-start.sh shell

EOF
}

# 打印带颜色的消息
print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# 检查前置条件
check_prerequisites() {
    print_info "检查前置条件..."

    # 检查 Docker
    if ! command -v docker &> /dev/null; then
        print_error "未安装 Docker，请先安装 Docker"
        exit 1
    fi
    print_success "Docker 已安装"

    # 检查 Docker Compose
    if ! command -v docker-compose &> /dev/null; then
        print_error "未安装 Docker Compose，请先安装 Docker Compose"
        exit 1
    fi
    print_success "Docker Compose 已安装"

    # 检查 Docker 守护进程
    if ! docker ps &> /dev/null; then
        print_error "Docker 守护进程未运行，请先启动 Docker"
        exit 1
    fi
    print_success "Docker 守护进程运行正常"

    echo ""
}

# 检查和创建配置文件
check_config() {
    print_info "检查配置文件..."

    # 检查 .env 文件
    if [ ! -f "$ENV_FILE" ]; then
        print_warning ".env 文件不存在"
        if [ -f ".env.docker" ]; then
            print_info "从 .env.docker 复制配置..."
            cp .env.docker .env
            print_success ".env 文件已创建"
            
            print_warning "请编辑 .env 文件并填入正确的 API Key"
            print_info "编辑命令: nano .env"
            echo ""
            read -p "是否现在编辑 .env 文件? (y/n) " -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                nano .env || vim .env
            fi
        else
            print_error ".env 和 .env.docker 文件都不存在"
            exit 1
        fi
    else
        print_success ".env 文件存在"
    fi

    # 检查 config 目录
    if [ ! -d "$CONFIG_DIR" ]; then
        print_info "创建 $CONFIG_DIR 目录..."
        mkdir -p "$CONFIG_DIR"
    fi

    # 检查 image_providers.yaml
    if [ ! -f "$CONFIG_DIR/image_providers.yaml" ]; then
        print_info "创建 $CONFIG_DIR/image_providers.yaml..."
        if [ -f "image_providers.yaml.example" ]; then
            cp image_providers.yaml.example "$CONFIG_DIR/image_providers.yaml"
            print_success "已从示例文件创建"
        else
            print_error "找不到 image_providers.yaml.example"
            exit 1
        fi
    else
        print_success "image_providers.yaml 存在"
    fi

    echo ""
}

# 启动应用
start_app() {
    local detach_flag="$1"

    print_info "正在启动应用..."

    if [ "$detach_flag" = "true" ]; then
        docker-compose --env-file "$ENV_FILE" up -d
        print_success "应用已在后台启动"
        print_info "访问地址: http://localhost:${DOCKER_PORT}/"
        print_info "查看日志: bash docker-start.sh logs -f"
    else
        print_info "按 Ctrl+C 停止应用"
        docker-compose --env-file "$ENV_FILE" up
    fi
}

# 停止应用
stop_app() {
    print_info "正在停止应用..."
    docker-compose --env-file "$ENV_FILE" stop
    print_success "应用已停止"
}

# 重启应用
restart_app() {
    print_info "正在重启应用..."
    docker-compose --env-file "$ENV_FILE" restart
    print_success "应用已重启"
}

# 重新构建
rebuild_app() {
    local detach_flag="$1"

    print_info "正在重新构建镜像并启动..."

    if [ "$detach_flag" = "true" ]; then
        docker-compose --env-file "$ENV_FILE" down
        docker-compose --env-file "$ENV_FILE" up -d --build
        print_success "应用已构建并在后台启动"
        print_info "访问地址: http://localhost:${DOCKER_PORT}/"
    else
        docker-compose --env-file "$ENV_FILE" down
        docker-compose --env-file "$ENV_FILE" up --build
    fi
}

# 查看日志
show_logs() {
    local follow_flag="$1"

    if [ "$follow_flag" = "true" ]; then
        print_info "显示实时日志（按 Ctrl+C 退出）..."
        docker-compose --env-file "$ENV_FILE" logs -f
    else
        docker-compose --env-file "$ENV_FILE" logs
    fi
}

# 清理
clean_app() {
    print_warning "这将停止并删除所有容器、网络和卷"
    read -p "确认继续? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_info "正在清理..."
        docker-compose --env-file "$ENV_FILE" down -v
        print_success "清理完成"
    else
        print_info "已取消"
    fi
}

# 查看状态
show_status() {
    print_info "应用状态:"
    echo ""
    docker-compose --env-file "$ENV_FILE" ps
    echo ""
}

# 进入容器 shell
enter_shell() {
    print_info "进入容器 shell（输入 exit 退出）..."
    docker-compose --env-file "$ENV_FILE" exec xiaohongshu-app sh
}

# 健康检查
health_check() {
    print_info "检查应用健康状态..."

    local max_attempts=30
    local attempt=0

    while [ $attempt -lt $max_attempts ]; do
        if curl -sf http://localhost:${DOCKER_PORT}/api/health > /dev/null 2>&1; then
            print_success "应用运行正常"
            print_info "应用信息:"
            curl -s http://localhost:${DOCKER_PORT}/ | grep -o '"message":"[^"]*"' || true
            echo ""
            return 0
        fi

        print_warning "应用还未就绪... ($((attempt + 1))/$max_attempts)"
        sleep 1
        ((attempt++))
    done

    print_error "应用无法访问，请检查日志"
    echo ""
    print_info "查看日志: bash docker-start.sh logs"
    return 1
}

# 主函数
main() {
    local command="${1:-start}"
    local detach="false"
    local follow="false"

    # 解析参数
    case "$command" in
        start|stop|restart|rebuild|logs|clean|status|shell|health)
            shift
            while [[ $# -gt 0 ]]; do
                case "$1" in
                    -d|--detach)
                        detach="true"
                        shift
                        ;;
                    -f|--follow)
                        follow="true"
                        shift
                        ;;
                    --port)
                        DOCKER_PORT="$2"
                        shift 2
                        ;;
                    --env-file)
                        ENV_FILE="$2"
                        shift 2
                        ;;
                    *)
                        shift
                        ;;
                esac
            done
            ;;
        help|--help|-h)
            show_help
            exit 0
            ;;
        *)
            print_error "未知命令: $command"
            show_help
            exit 1
            ;;
    esac

    # 检查前置条件
    check_prerequisites

    # 检查配置
    check_config

    # 执行命令
    case "$command" in
        start)
            start_app "$detach"
            if [ "$detach" = "true" ]; then
                sleep 2
                health_check
            fi
            ;;
        stop)
            stop_app
            ;;
        restart)
            restart_app
            sleep 2
            health_check
            ;;
        rebuild)
            rebuild_app "$detach"
            if [ "$detach" = "true" ]; then
                sleep 3
                health_check
            fi
            ;;
        logs)
            show_logs "$follow"
            ;;
        clean)
            clean_app
            ;;
        status)
            show_status
            ;;
        shell)
            enter_shell
            ;;
        health)
            health_check
            ;;
    esac
}

# 运行主函数
main "$@"
