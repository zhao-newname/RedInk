#!/bin/bash

# ==============================================================================
# 小红书图文生成器 - Docker 配置检查脚本
# ==============================================================================
# 
# 检查 Docker 部署所需的所有配置是否正确设置
#
# 使用方式: bash docker-check-config.sh
#
# ==============================================================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# 计数器
CHECKS_PASSED=0
CHECKS_FAILED=0
CHECKS_WARNING=0

# 打印函数
print_header() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║ 小红书图文生成器 - Docker 配置检查     ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
    echo ""
}

print_check() {
    echo ""
    echo -e "${CYAN}[检查] $1${NC}"
}

print_pass() {
    echo -e "${GREEN}  ✓${NC} $1"
    ((CHECKS_PASSED++))
}

print_fail() {
    echo -e "${RED}  ✗${NC} $1"
    ((CHECKS_FAILED++))
}

print_warning() {
    echo -e "${YELLOW}  ⚠${NC} $1"
    ((CHECKS_WARNING++))
}

print_info() {
    echo -e "${BLUE}  ℹ${NC} $1"
}

# 最终摘要
print_summary() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║            检查结果摘要                ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -e "  ${GREEN}通过: $CHECKS_PASSED${NC}"
    echo -e "  ${YELLOW}警告: $CHECKS_WARNING${NC}"
    echo -e "  ${RED}失败: $CHECKS_FAILED${NC}"
    echo ""

    if [ $CHECKS_FAILED -eq 0 ]; then
        if [ $CHECKS_WARNING -eq 0 ]; then
            echo -e "${GREEN}✓ 所有检查通过！可以启动应用。${NC}"
            return 0
        else
            echo -e "${YELLOW}⚠ 检查通过但有警告，请检查是否需要处理。${NC}"
            return 0
        fi
    else
        echo -e "${RED}✗ 检查失败，请根据上述错误提示进行修正。${NC}"
        return 1
    fi
}

# 检查 Docker
check_docker() {
    print_check "Docker 环境"

    if ! command -v docker &> /dev/null; then
        print_fail "Docker 未安装"
        print_info "请从 https://www.docker.com 下载安装"
        return 1
    fi
    print_pass "Docker 已安装"

    local docker_version=$(docker --version)
    print_info "$docker_version"

    if ! docker ps &> /dev/null; then
        print_fail "Docker 守护进程未运行"
        print_info "请启动 Docker 服务"
        return 1
    fi
    print_pass "Docker 守护进程运行正常"

    return 0
}

# 检查 Docker Compose
check_docker_compose() {
    print_check "Docker Compose"

    if ! command -v docker-compose &> /dev/null; then
        print_fail "Docker Compose 未安装"
        print_info "请从 https://www.docker.com 下载安装"
        return 1
    fi
    print_pass "Docker Compose 已安装"

    local compose_version=$(docker-compose --version)
    print_info "$compose_version"

    return 0
}

# 检查项目文件
check_project_files() {
    print_check "项目文件"

    local files=(
        "Dockerfile"
        "docker-compose.yml"
        ".dockerignore"
        "backend/"
        "frontend/"
        "pyproject.toml"
    )

    for file in "${files[@]}"; do
        if [ ! -e "$file" ]; then
            print_fail "文件 $file 不存在"
            return 1
        fi
    done
    print_pass "所有必需的项目文件存在"

    return 0
}

# 检查环境配置
check_env_config() {
    print_check "环境变量配置"

    if [ ! -f ".env" ]; then
        print_warning ".env 文件不存在"
        if [ -f ".env.docker" ]; then
            print_info "存在 .env.docker，可以复制使用"
            return 0
        fi
        return 1
    fi
    print_pass ".env 文件存在"

    # 检查必需的 API Key
    if ! grep -q "GOOGLE_CLOUD_API_KEY" .env; then
        print_fail ".env 中缺少 GOOGLE_CLOUD_API_KEY"
        return 1
    fi
    print_pass "GOOGLE_CLOUD_API_KEY 已配置"

    if ! grep -q "IMAGE_API_KEY" .env; then
        print_fail ".env 中缺少 IMAGE_API_KEY"
        return 1
    fi
    print_pass "IMAGE_API_KEY 已配置"

    # 检查是否为空值
    if grep -q "GOOGLE_CLOUD_API_KEY=your_\|GOOGLE_CLOUD_API_KEY=$" .env; then
        print_fail "GOOGLE_CLOUD_API_KEY 未设置实际值"
        return 1
    fi

    if grep -q "IMAGE_API_KEY=your_\|IMAGE_API_KEY=$" .env; then
        print_fail "IMAGE_API_KEY 未设置实际值"
        return 1
    fi

    print_pass "API Key 值已设置"

    return 0
}

# 检查图片服务商配置
check_providers_config() {
    print_check "图片生成服务商配置"

    local config_dir="config"
    if [ ! -d "$config_dir" ]; then
        print_warning "config 目录不存在"
        return 1
    fi

    local config_file="$config_dir/image_providers.yaml"
    if [ ! -f "$config_file" ]; then
        print_warning "image_providers.yaml 不存在"
        if [ -f "image_providers.yaml.example" ]; then
            print_info "存在 image_providers.yaml.example，可以复制使用"
            return 0
        fi
        return 1
    fi
    print_pass "image_providers.yaml 存在"

    # 检查 active_provider
    if ! grep -q "^active_provider:" "$config_file"; then
        print_fail "image_providers.yaml 中未设置 active_provider"
        return 1
    fi

    local active_provider=$(grep "^active_provider:" "$config_file" | awk '{print $2}')
    print_pass "active_provider 已设置: $active_provider"

    return 0
}

# 检查磁盘空间
check_disk_space() {
    print_check "磁盘空间"

    local available=$(df . | tail -1 | awk '{print $4}')
    local available_gb=$((available / 1024 / 1024))

    if [ "$available_gb" -lt 2 ]; then
        print_fail "可用磁盘空间不足 (${available_gb}GB < 2GB)"
        return 1
    fi

    print_pass "磁盘空间充足 (${available_gb}GB)"
    return 0
}

# 检查内存
check_memory() {
    print_check "系统内存"

    if command -v free &> /dev/null; then
        local total_memory=$(free -m | awk 'NR==2 {print $2}')
        if [ "$total_memory" -lt 2048 ]; then
            print_warning "系统内存较小 (${total_memory}MB < 2GB)"
            print_info "可能影响应用性能，但应该仍能运行"
            return 0
        fi
        print_pass "系统内存充足 (${total_memory}MB)"
    else
        print_warning "无法检查系统内存"
    fi

    return 0
}

# 检查端口
check_ports() {
    print_check "端口可用性"

    local port=$(grep "DOCKER_PORT=" .env | cut -d= -f2 | xargs)
    port="${port:-12398}"

    if command -v lsof &> /dev/null; then
        if lsof -i ":$port" > /dev/null 2>&1; then
            print_fail "端口 $port 已被占用"
            lsof -i ":$port" | grep -v COMMAND
            return 1
        fi
    elif command -v netstat &> /dev/null; then
        if netstat -tuln | grep -q ":$port"; then
            print_fail "端口 $port 已被占用"
            return 1
        fi
    fi

    print_pass "端口 $port 可用"
    return 0
}

# 检查是否有额外的警告
check_additional() {
    print_check "其他检查"

    # 检查 .gitignore
    if [ ! -f ".gitignore" ]; then
        print_warning ".gitignore 文件不存在"
    else
        if ! grep -q "\.env" .gitignore; then
            print_warning ".gitignore 中未排除 .env 文件（避免泄露 API Key）"
        else
            print_pass ".gitignore 正确配置了敏感文件"
        fi
    fi

    # 检查是否在 git 中
    if git rev-parse --git-dir > /dev/null 2>&1; then
        if git check-ignore .env > /dev/null 2>&1; then
            print_pass ".env 已被 git 正确忽略"
        else
            print_warning ".env 可能会被 git 跟踪（请检查）"
        fi
    fi

    return 0
}

# 主函数
main() {
    print_header

    echo "检查所需的 Docker 部署条件..."
    echo ""

    check_docker || true
    check_docker_compose || true
    check_project_files || true
    check_env_config || true
    check_providers_config || true
    check_disk_space || true
    check_memory || true
    check_ports || true
    check_additional || true

    print_summary
}

main "$@"
