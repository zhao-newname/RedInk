.PHONY: help docker-help docker-build docker-up docker-down docker-logs docker-shell docker-clean docker-status

# 默认目标
.DEFAULT_GOAL := help

# 变量
DOCKER_COMPOSE := docker-compose
ENV_FILE := .env
DOCKER_PORT := 12398

# 颜色输出
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[1;33m
RED := \033[0;31m
NC := \033[0m # No Color

help:
	@echo "$(BLUE)╔════════════════════════════════════════╗$(NC)"
	@echo "$(BLUE)║    小红书图文生成器 - Makefile 帮助    ║$(NC)"
	@echo "$(BLUE)╚════════════════════════════════════════╝$(NC)"
	@echo ""
	@echo "$(GREEN)Docker 命令:$(NC)"
	@echo "  make docker-help       显示 Docker 帮助信息"
	@echo "  make docker-build      构建 Docker 镜像"
	@echo "  make docker-up         启动应用（后台）"
	@echo "  make docker-down       停止应用"
	@echo "  make docker-restart    重启应用"
	@echo "  make docker-logs       查看应用日志"
	@echo "  make docker-shell      进入容器 shell"
	@echo "  make docker-clean      清理所有容器和卷"
	@echo "  make docker-status     查看应用状态"
	@echo ""
	@echo "$(GREEN)快捷命令:$(NC)"
	@echo "  make build             同 docker-build"
	@echo "  make up                同 docker-up"
	@echo "  make down              同 docker-down"
	@echo "  make logs              同 docker-logs"
	@echo "  make status            同 docker-status"
	@echo ""
	@echo "$(GREEN)配置命令:$(NC)"
	@echo "  make config-init       初始化配置文件"
	@echo "  make config-edit       编辑 .env 文件"
	@echo ""

docker-help:
	@echo "$(BLUE)Docker 部署选项:$(NC)"
	@echo ""
	@echo "$(GREEN)快速开始:$(NC)"
	@echo "  1. 初始化配置文件:"
	@echo "     make config-init"
	@echo ""
	@echo "  2. 编辑 API 密钥:"
	@echo "     make config-edit"
	@echo ""
	@echo "  3. 启动应用:"
	@echo "     make docker-up"
	@echo ""
	@echo "  4. 访问应用:"
	@echo "     http://localhost:$(DOCKER_PORT)"
	@echo ""
	@echo "$(YELLOW)更多信息: 查看 DOCKER_DEPLOYMENT.md$(NC)"
	@echo ""

config-init:
	@echo "$(BLUE)初始化配置文件...$(NC)"
	@if [ ! -f "$(ENV_FILE)" ]; then \
		cp .env.docker $(ENV_FILE); \
		echo "$(GREEN)✓$(NC) $(ENV_FILE) 已创建"; \
	else \
		echo "$(YELLOW)⚠$(NC) $(ENV_FILE) 已存在"; \
	fi
	@if [ ! -f "config/image_providers.yaml" ]; then \
		mkdir -p config; \
		cp image_providers.yaml.example config/image_providers.yaml; \
		echo "$(GREEN)✓$(NC) config/image_providers.yaml 已创建"; \
	else \
		echo "$(YELLOW)⚠$(NC) config/image_providers.yaml 已存在"; \
	fi

config-edit:
	@echo "$(BLUE)编辑配置文件...$(NC)"
	@if [ -z "$$EDITOR" ]; then \
		nano $(ENV_FILE); \
	else \
		$$EDITOR $(ENV_FILE); \
	fi

docker-build:
	@echo "$(BLUE)构建 Docker 镜像...$(NC)"
	$(DOCKER_COMPOSE) --env-file $(ENV_FILE) build

docker-up: config-init
	@echo "$(BLUE)启动应用...$(NC)"
	$(DOCKER_COMPOSE) --env-file $(ENV_FILE) up -d
	@echo "$(GREEN)✓ 应用已启动$(NC)"
	@echo "$(BLUE)访问地址: http://localhost:$(DOCKER_PORT)$(NC)"
	@sleep 2
	@$(MAKE) docker-status

docker-down:
	@echo "$(BLUE)停止应用...$(NC)"
	$(DOCKER_COMPOSE) --env-file $(ENV_FILE) down
	@echo "$(GREEN)✓ 应用已停止$(NC)"

docker-restart:
	@echo "$(BLUE)重启应用...$(NC)"
	$(DOCKER_COMPOSE) --env-file $(ENV_FILE) restart
	@echo "$(GREEN)✓ 应用已重启$(NC)"
	@sleep 2
	@$(MAKE) docker-status

docker-logs:
	@echo "$(BLUE)显示实时日志（Ctrl+C 退出）...$(NC)"
	$(DOCKER_COMPOSE) --env-file $(ENV_FILE) logs -f

docker-shell:
	@echo "$(BLUE)进入容器 shell...$(NC)"
	$(DOCKER_COMPOSE) --env-file $(ENV_FILE) exec xiaohongshu-app sh

docker-clean:
	@echo "$(RED)警告: 这将删除所有容器和卷（数据丢失）$(NC)"
	@read -p "确认继续? (y/n) " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		echo "$(BLUE)正在清理...$(NC)"; \
		$(DOCKER_COMPOSE) --env-file $(ENV_FILE) down -v; \
		echo "$(GREEN)✓ 清理完成$(NC)"; \
	else \
		echo "$(YELLOW)已取消$(NC)"; \
	fi

docker-status:
	@echo "$(BLUE)应用状态:$(NC)"
	@$(DOCKER_COMPOSE) --env-file $(ENV_FILE) ps

# 快捷命令别名
build: docker-build
up: docker-up
down: docker-down
restart: docker-restart
logs: docker-logs
status: docker-status
shell: docker-shell
clean: docker-clean

# 开发相关命令
dev-start:
	@echo "$(BLUE)启动开发环境...$(NC)"
	@echo "后端: http://localhost:12398"
	@echo "前端: http://localhost:5173"
	@$(MAKE) docker-up

dev-logs:
	@echo "$(BLUE)显示所有服务日志...$(NC)"
	@$(DOCKER_COMPOSE) --env-file $(ENV_FILE) logs -f

.PHONY: config-init config-edit dev-start dev-logs
