#!/bin/bash

# Docker 部署验证脚本
# 此脚本验证 Docker 部署的所有文件和配置是否完整

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 计数器
TOTAL_CHECKS=0
PASSED_CHECKS=0
FAILED_CHECKS=0

# 检查函数
check_file() {
    local file=$1
    local description=$2
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} $description: $file"
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
    else
        echo -e "${RED}✗${NC} $description: $file ${RED}(NOT FOUND)${NC}"
        FAILED_CHECKS=$((FAILED_CHECKS + 1))
    fi
}

check_directory() {
    local dir=$1
    local description=$2
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    
    if [ -d "$dir" ]; then
        echo -e "${GREEN}✓${NC} $description: $dir"
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
    else
        echo -e "${RED}✗${NC} $description: $dir ${RED}(NOT FOUND)${NC}"
        FAILED_CHECKS=$((FAILED_CHECKS + 1))
    fi
}

check_command() {
    local cmd=$1
    local description=$2
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    
    if command -v "$cmd" &> /dev/null; then
        local version=$($cmd --version 2>&1 | head -1)
        echo -e "${GREEN}✓${NC} $description: $version"
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
    else
        echo -e "${RED}✗${NC} $description: ${RED}(NOT INSTALLED)${NC}"
        FAILED_CHECKS=$((FAILED_CHECKS + 1))
    fi
}

# 欢迎消息
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}小红书 Docker 部署验证脚本${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo ""

# 1. 检查系统命令
echo -e "${BLUE}1. 检查系统命令...${NC}"
check_command "docker" "Docker"
check_command "git" "Git"
echo ""

# 2. 检查 Docker 文件
echo -e "${BLUE}2. 检查 Docker 文件...${NC}"
check_file "Dockerfile" "Dockerfile (完整版)"
check_file "Dockerfile.prod" "Dockerfile (简化版)"
check_file "docker-compose.yml" "Docker Compose 配置 (开发版)"
check_file "docker-compose.prod.yml" "Docker Compose 配置 (生产版)"
check_file "docker-compose.prod-simple.yml" "Docker Compose 配置 (简化版)"
check_file ".dockerignore" ".dockerignore"
echo ""

# 3. 检查配置文件
echo -e "${BLUE}3. 检查配置文件...${NC}"
check_file ".env" ".env 环境配置"
check_file ".env.docker" ".env.docker 示例"
check_file ".env.prod" ".env.prod 生产示例"
check_file ".env.example" ".env.example 示例"
check_file "config/image_providers.yaml" "图片生成服务配置"
check_file "image_providers.yaml.example" "图片生成服务配置示例"
echo ""

# 4. 检查项目结构
echo -e "${BLUE}4. 检查项目目录...${NC}"
check_directory "backend" "后端源代码"
check_directory "frontend" "前端源代码"
check_directory "config" "配置目录"
check_directory "output" "输出目录"
check_directory "history" "历史数据目录"
check_directory "frontend/dist" "前端构建输出"
echo ""

# 5. 检查后端文件
echo -e "${BLUE}5. 检查后端文件...${NC}"
check_file "backend/app.py" "Flask 应用主文件"
check_file "backend/config.py" "配置模块"
check_file "pyproject.toml" "Python 项目配置"
check_file "uv.lock" "uv 依赖锁文件"
echo ""

# 6. 检查前端文件
echo -e "${BLUE}6. 检查前端文件...${NC}"
check_file "frontend/package.json" "前端包配置"
check_file "frontend/pnpm-lock.yaml" "pnpm 依赖锁文件"
check_file "frontend/vite.config.ts" "Vite 配置"
check_file "frontend/tsconfig.json" "TypeScript 配置"
echo ""

# 7. 检查脚本文件
echo -e "${BLUE}7. 检查辅助脚本...${NC}"
check_file "docker-start.sh" "Docker 启动脚本"
check_file "docker-check-config.sh" "Docker 配置检查脚本"
check_file "docker-deploy-verify.sh" "Docker 部署验证脚本"
check_file "Makefile" "Makefile"
echo ""

# 8. 检查文档文件
echo -e "${BLUE}8. 检查文档文件...${NC}"
check_file "DOCKER_INDEX.md" "Docker 快速导航"
check_file "DOCKER_QUICKSTART.md" "Docker 快速开始"
check_file "DOCKER_DEPLOYMENT.md" "Docker 部署详细指南"
check_file "DOCKER_FILES_README.md" "Docker 文件说明"
check_file "DOCKER_DEPLOYMENT_OFFLINE.md" "离线部署指南"
check_file "README.md" "项目 README"
echo ""

# 9. 检查示例文件
echo -e "${BLUE}9. 检查示例和配置文件...${NC}"
check_file "nginx.conf.example" "Nginx 配置示例"
check_file "xiaohongshu-docker.service.example" "Systemd 服务示例"
echo ""

# 10. 验证 .env 配置
echo -e "${BLUE}10. 验证 .env 配置...${NC}"
if [ -f ".env" ]; then
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    if grep -q "GOOGLE_CLOUD_API_KEY" .env; then
        echo -e "${GREEN}✓${NC} GOOGLE_CLOUD_API_KEY 已配置"
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
    else
        echo -e "${YELLOW}!${NC} GOOGLE_CLOUD_API_KEY 未填入（可选择跳过）"
    fi
    
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    if grep -q "IMAGE_API_KEY" .env; then
        echo -e "${GREEN}✓${NC} IMAGE_API_KEY 已配置"
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
    else
        echo -e "${YELLOW}!${NC} IMAGE_API_KEY 未填入（可选择跳过）"
    fi
fi
echo ""

# 11. 检查 Docker 运行状态
echo -e "${BLUE}11. 检查 Docker 服务...${NC}"
TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
if docker ps &> /dev/null; then
    echo -e "${GREEN}✓${NC} Docker 守护进程运行中"
    PASSED_CHECKS=$((PASSED_CHECKS + 1))
else
    echo -e "${RED}✗${NC} Docker 守护进程 ${RED}(未运行)${NC}"
    FAILED_CHECKS=$((FAILED_CHECKS + 1))
fi
echo ""

# 12. 显示现有镜像和容器
echo -e "${BLUE}12. Docker 镜像和容器状态...${NC}"
if docker images &> /dev/null; then
    image_count=$(docker images --format "{{.Repository}}:{{.Tag}}" | wc -l)
    echo -e "${GREEN}✓${NC} 本地镜像数量: $image_count"
fi

if docker ps -a &> /dev/null; then
    container_count=$(docker ps -a --format "{{.ID}}" | wc -l)
    echo -e "${GREEN}✓${NC} 本地容器数量: $container_count"
    
    if docker ps -a --format "{{.Names}}" | grep -q "xiaohongshu"; then
        echo -e "${GREEN}✓${NC} xiaohongshu 容器已存在"
        if docker ps --format "{{.Names}}" | grep -q "xiaohongshu"; then
            echo -e "${GREEN}✓${NC} xiaohongshu 容器运行中"
        fi
    fi
fi
echo ""

# 总结
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}验证总结${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo "总检查项: $TOTAL_CHECKS"
echo -e "通过: ${GREEN}$PASSED_CHECKS${NC}"
echo -e "失败: ${RED}$FAILED_CHECKS${NC}"

if [ $FAILED_CHECKS -eq 0 ]; then
    echo -e ""
    echo -e "${GREEN}✓ 所有检查通过！${NC}"
    echo -e ""
    echo "接下来可以运行:"
    echo "  1. 启动 Docker 服务: ${BLUE}bash docker-start.sh start -d${NC}"
    echo "  2. 或使用 docker-compose: ${BLUE}docker compose up -d${NC}"
    echo "  3. 查看应用状态: ${BLUE}docker logs xiaohongshu-generator${NC}"
    echo "  4. 访问应用: ${BLUE}http://localhost:12398${NC}"
else
    echo -e ""
    echo -e "${RED}✗ 部分检查失败！${NC}"
    echo "请检查上面标记为 ${RED}(NOT FOUND)${NC} 的文件"
fi
echo ""
