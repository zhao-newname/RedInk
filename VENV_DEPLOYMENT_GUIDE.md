# Python venv 部署指南 - 红墨 AI图文生成器

> 详细的虚拟环境部署步骤，适合本地开发和服务器部署

## 📋 目录

- [系统要求](#系统要求)
- [快速开始（5分钟）](#快速开始5分钟)
- [详细部署步骤](#详细部署步骤)
- [配置指南](#配置指南)
- [启动服务](#启动服务)
- [常见问题](#常见问题)
- [生产环境部署](#生产环境部署)
- [故障排查](#故障排查)

---

## 系统要求

### 最低要求
- **OS**: Linux / macOS / Windows (WSL2)
- **Python**: 3.11 或更高版本
- **Node.js**: 18 或更高版本
- **包管理**: pnpm（前端）、uv（后端）

### 推荐配置
- **CPU**: 2核心+
- **内存**: 4GB+
- **磁盘**: 5GB+ 空闲空间
- **网络**: 良好的国际网络连接（用于调用 API）

---

## 快速开始（5分钟）

如果你已经了解部署流程，可以直接按照以下步骤快速启动：

```bash
# 1. 克隆项目
git clone https://github.com/HisMax/RedInk.git
cd RedInk

# 2. 配置 API 服务
cp text_providers.yaml.example text_providers.yaml
cp image_providers.yaml.example image_providers.yaml
# 编辑配置文件，填入你的 API Key

# 3. 创建虚拟环境并安装依赖
python3 -m venv venv
source venv/bin/activate  # Linux/macOS: 或 venv\Scripts\activate (Windows)
uv sync

# 4. 安装前端依赖
cd frontend
pnpm install
cd ..

# 5. 启动后端
uv run python -m backend.app &

# 6. 启动前端（新终端）
cd frontend
pnpm dev

# 访问 http://localhost:5173
```

---

## 详细部署步骤

### 第一步：系统环境检查

#### 1.1 检查 Python 版本

```bash
python3 --version
# 输出示例: Python 3.11.5
# 确保版本 >= 3.11
```

如果没有 Python 3.11，可以：

**Linux (Ubuntu/Debian)**:
```bash
sudo apt update
sudo apt install python3.11 python3.11-venv python3.11-dev
```

**Linux (CentOS/RHEL)**:
```bash
sudo yum install python3.11 python3.11-devel
```

**macOS**:
```bash
brew install python@3.11
# 或使用 pyenv
brew install pyenv
pyenv install 3.11.5
```

**Windows**:
- 从 [python.org](https://www.python.org/downloads/) 下载安装程序
- 或使用 Windows Package Manager: `winget install Python.Python.3.11`

#### 1.2 检查 Node.js 版本

```bash
node --version
npm --version
# 输出示例: v18.0.0
```

如果没有 Node.js，可以从 [nodejs.org](https://nodejs.org/) 下载或使用包管理器安装。

#### 1.3 安装 pnpm（前端包管理）

```bash
# 使用 npm 安装 pnpm
npm install -g pnpm

# 验证安装
pnpm --version
# 输出示例: 8.6.0
```

#### 1.4 安装 uv（后端包管理）

```bash
# macOS 和 Linux
curl -LsSf https://astral.sh/uv/install.sh | sh
# 或使用 pip 安装
pip install uv

# Windows (PowerShell)
powershell -c "irm https://astral.sh/uv/install.ps1 | iex"
# 或使用 pip 安装
pip install uv

# 验证安装
uv --version
```

---

### 第二步：项目克隆

```bash
# 克隆项目仓库
git clone https://github.com/HisMax/RedInk.git
cd RedInk

# 查看项目结构
ls -la
# 输出示例:
# .git/
# backend/         - 后端代码
# frontend/        - 前端代码
# history/         - 历史记录存储
# uv.lock          - Python 依赖锁文件
# pyproject.toml   - Python 项目配置
```

---

### 第三步：创建虚拟环境

#### 3.1 创建虚拟环境

```bash
# 使用 Python 3.11 创建虚拟环境
python3 -m venv venv

# 验证虚拟环境创建成功
ls -la venv/
# 输出示例:
# bin/  include/  lib/  pyvenv.cfg
```

#### 3.2 激活虚拟环境

**Linux / macOS**:
```bash
source venv/bin/activate
# 提示符会变为: (venv) user@host:~/RedInk$
```

**Windows (CMD)**:
```bash
venv\Scripts\activate.bat
# 提示符会变为: (venv) C:\Users\...>
```

**Windows (PowerShell)**:
```bash
venv\Scripts\Activate.ps1
# 如果遇到执行策略错误，运行:
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### 3.3 升级 pip

```bash
pip install --upgrade pip
# 输出示例: Successfully installed pip-23.0.0
```

---

### 第四步：配置 API 服务

#### 4.1 复制配置文件

```bash
# 复制文本生成配置模板
cp text_providers.yaml.example text_providers.yaml

# 复制图片生成配置模板
cp image_providers.yaml.example image_providers.yaml

# 验证配置文件创建
ls -la *.yaml
```

#### 4.2 编辑配置文件

**方式一：使用编辑器（推荐开发时使用）**

```bash
# 编辑文本生成配置
nano text_providers.yaml
# 或使用 VS Code, vim 等编辑器

# 编辑图片生成配置
nano image_providers.yaml
```

**方式二：Web 界面配置（推荐生产使用）**

启动应用后，访问 `http://localhost:5173` 的设置页面进行可视化配置。

#### 4.3 配置文件详解

**text_providers.yaml** - 文本生成配置

```yaml
# 当前激活的服务商
active_provider: gemini

providers:
  # Google Gemini（推荐）
  gemini:
    type: google_gemini
    api_key: AIzaxxxxxxxxxxxxxxxxxxxxxxxxx
    model: gemini-2.0-flash

  # OpenAI 官方 API
  openai:
    type: openai_compatible
    api_key: sk-xxxxxxxxxxxxxxxxxxxx
    base_url: https://api.openai.com/v1
    model: gpt-4o
```

**image_providers.yaml** - 图片生成配置

```yaml
# 当前激活的服务商
active_provider: gemini

providers:
  # Google Gemini（推荐）
  gemini:
    type: google_genai
    api_key: AIzaxxxxxxxxxxxxxxxxxxxxxxxxx
    model: gemini-3-pro-image-preview
    high_concurrency: false  # GCP 试用账号不建议启用

  # OpenAI
  openai:
    type: image_api
    api_key: sk-xxxxxxxxxxxxxxxxxxxx
    base_url: https://api.openai.com/v1
    model: dall-e-3
    high_concurrency: false
```

**关键参数说明：**

| 参数 | 说明 | 示例 |
|------|------|------|
| `active_provider` | 当前使用的服务商 | `gemini` 或 `openai` |
| `type` | 服务商类型 | `google_genai`, `openai_compatible`, `image_api` |
| `api_key` | API 密钥（必填） | `sk-xxxxx` 或 `AIzaxxx` |
| `model` | 模型名称 | `gpt-4o`, `gemini-3-pro` |
| `high_concurrency` | 高并发模式 | `true` 或 `false` |

---

### 第五步：安装后端依赖

#### 5.1 使用 uv 同步依赖

```bash
# 确保虚拟环境已激活
source venv/bin/activate

# 同步依赖（推荐）
uv sync

# 或者从 uv.lock 安装（完全可重现）
uv pip install -r requirements.txt  # 如果有的话
```

#### 5.2 验证依赖安装

```bash
# 列出已安装的包
pip list

# 输出示例:
# Package          Version
# flask            3.0.0
# flask-cors       4.0.0
# google-genai      1.0.0
# python-dotenv    1.0.0
# ...
```

#### 5.3 依赖说明

| 包名 | 版本 | 用途 |
|------|------|------|
| `flask` | >=3.0.0 | Web 框架 |
| `flask-cors` | >=4.0.0 | 跨域资源共享 |
| `google-genai` | >=1.0.0 | Google Gemini API |
| `python-dotenv` | >=1.0.0 | 环境变量管理 |
| `pyyaml` | >=6.0.0 | YAML 配置解析 |
| `requests` | >=2.31.0 | HTTP 请求库 |
| `pillow` | >=12.0.0 | 图像处理 |

---

### 第六步：安装前端依赖

#### 6.1 进入前端目录

```bash
cd frontend
```

#### 6.2 使用 pnpm 安装依赖

```bash
# 安装依赖
pnpm install

# 或使用 --frozen-lockfile 确保版本一致（CI 环境推荐）
pnpm install --frozen-lockfile

# 输出示例:
# Packages in scope: xiaohongshu-generator-frontend
# Installing from lockfile
# + vue@3.4.0
# + vite@5.0.0
# ...
# Progress: resolved 10, reused 10, downloaded 0
# Done in 2.0s
```

#### 6.3 验证前端依赖

```bash
# 列出已安装的依赖
pnpm list

# 输出示例:
# xiaohongshu-generator-frontend@0.1.0
# ├── axios@1.6.0
# ├── pinia@2.1.0
# ├── vue@3.4.0
# └── vue-router@4.2.0
```

#### 6.4 返回项目根目录

```bash
cd ..
```

---

## 启动服务

### 方式一：独立终端启动（推荐学习阶段）

#### 终端 1：启动后端服务

```bash
# 激活虚拟环境
source venv/bin/activate

# 启动后端服务
uv run python -m backend.app

# 输出示例:
# WARNING: This is a development server. Do not use it in production deployments.
#  * Running on all addresses (0.0.0.0)
#  * Running on http://127.0.0.1:12398
# Press CTRL+C to quit
```

**后端服务说明：**
- 地址: `http://localhost:12398`
- API 端点: `/api/outline`, `/api/generate`, 等
- 支持热重载: 代码修改时自动重新加载

#### 终端 2：启动前端开发服务

```bash
# 进入前端目录
cd frontend

# 启动开发服务器
pnpm dev

# 输出示例:
#   VITE v5.0.0  ready in 1234 ms
#   ➜  Local:   http://localhost:5173/
#   ➜  press h to show help
```

**前端服务说明：**
- 地址: `http://localhost:5173`
- 支持热模块替换 (HMR)
- 自动重编译

#### 终端 3：访问应用

```bash
# 打开浏览器访问前端
open http://localhost:5173  # macOS
# 或手动访问 http://localhost:5173

# 查看后端 API 状态
curl http://localhost:12398/api/health
# 或在浏览器访问 http://localhost:12398
```

---

### 方式二：后台启动脚本

#### 创建启动脚本：`start.sh`

```bash
#!/bin/bash

# 红墨 venv 启动脚本

# 获取脚本所在目录
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}================================${NC}"
echo -e "${BLUE}    红墨 AI图文生成器 启动脚本${NC}"
echo -e "${BLUE}================================${NC}"

# 检查虚拟环境
if [ ! -d "venv" ]; then
    echo -e "${YELLOW}⚠ 未检测到虚拟环境，正在创建...${NC}"
    python3 -m venv venv
fi

# 激活虚拟环境
source venv/bin/activate

# 安装/更新依赖
echo -e "${YELLOW}📦 更新依赖...${NC}"
uv sync

# 安装前端依赖
if [ ! -d "frontend/node_modules" ]; then
    echo -e "${YELLOW}📦 安装前端依赖...${NC}"
    cd frontend
    pnpm install
    cd ..
fi

# 检查配置文件
if [ ! -f "text_providers.yaml" ]; then
    echo -e "${YELLOW}⚠ 未检测到 text_providers.yaml，正在复制...${NC}"
    cp text_providers.yaml.example text_providers.yaml
    echo -e "${YELLOW}⚠ 请编辑 text_providers.yaml 填写你的 API Key${NC}"
fi

if [ ! -f "image_providers.yaml" ]; then
    echo -e "${YELLOW}⚠ 未检测到 image_providers.yaml，正在复制...${NC}"
    cp image_providers.yaml.example image_providers.yaml
    echo -e "${YELLOW}⚠ 请编辑 image_providers.yaml 填写你的 API Key${NC}"
fi

# 启动后端
echo -e "${GREEN}🚀 启动后端服务...${NC}"
nohup uv run python -m backend.app > backend.log 2>&1 &
BACKEND_PID=$!
echo -e "${GREEN}✓ 后端进程 PID: $BACKEND_PID${NC}"

# 等待后端启动
sleep 2

# 启动前端
echo -e "${GREEN}🚀 启动前端服务...${NC}"
cd frontend
nohup pnpm dev > ../frontend.log 2>&1 &
FRONTEND_PID=$!
echo -e "${GREEN}✓ 前端进程 PID: $FRONTEND_PID${NC}"
cd ..

# 保存 PID 方便后续停止
echo "$BACKEND_PID" > .backend.pid
echo "$FRONTEND_PID" > .frontend.pid

echo -e "${BLUE}================================${NC}"
echo -e "${GREEN}✓ 启动成功！${NC}"
echo -e "${BLUE}================================${NC}"
echo ""
echo -e "📱 前端地址: ${GREEN}http://localhost:5173${NC}"
echo -e "🔌 后端地址: ${GREEN}http://localhost:12398${NC}"
echo ""
echo -e "查看日志:"
echo -e "  后端日志: tail -f backend.log"
echo -e "  前端日志: tail -f frontend.log"
echo ""
echo -e "停止服务:"
echo -e "  bash stop.sh"
echo ""
```

#### 创建停止脚本：`stop.sh`

```bash
#!/bin/bash

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}停止服务...${NC}"

# 停止后端
if [ -f ".backend.pid" ]; then
    BACKEND_PID=$(cat .backend.pid)
    if kill -0 "$BACKEND_PID" 2>/dev/null; then
        kill "$BACKEND_PID"
        echo -e "${GREEN}✓ 后端进程已停止 (PID: $BACKEND_PID)${NC}"
    fi
    rm .backend.pid
fi

# 停止前端
if [ -f ".frontend.pid" ]; then
    FRONTEND_PID=$(cat .frontend.pid)
    if kill -0 "$FRONTEND_PID" 2>/dev/null; then
        kill "$FRONTEND_PID"
        echo -e "${GREEN}✓ 前端进程已停止 (PID: $FRONTEND_PID)${NC}"
    fi
    rm .frontend.pid
fi

echo -e "${GREEN}✓ 所有服务已停止${NC}"
```

#### 使用启动脚本

```bash
# 赋予执行权限
chmod +x start.sh stop.sh

# 启动服务
bash start.sh

# 停止服务
bash stop.sh

# 查看日志
tail -f backend.log
tail -f frontend.log
```

---

### 方式三：使用 systemd 管理（生产环境推荐）

#### 创建后端 systemd 服务文件

创建 `/etc/systemd/system/xiaohongshu-backend.service`:

```ini
[Unit]
Description=红墨 AI 后端服务
After=network.target

[Service]
Type=simple
User=xiaohongshu
WorkingDirectory=/home/xiaohongshu/RedInk
Environment="PATH=/home/xiaohongshu/RedInk/venv/bin"
Environment="PYTHONUNBUFFERED=1"
ExecStart=/home/xiaohongshu/RedInk/venv/bin/python -m backend.app
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
```

#### 创建前端 systemd 服务文件

创建 `/etc/systemd/system/xiaohongshu-frontend.service`:

```ini
[Unit]
Description=红墨 AI 前端服务
After=network.target

[Service]
Type=simple
User=xiaohongshu
WorkingDirectory=/home/xiaohongshu/RedInk/frontend
Environment="PATH=/home/xiaohongshu/RedInk/venv/bin:/usr/local/bin"
ExecStart=/usr/local/bin/pnpm dev
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
```

#### 启用和管理服务

```bash
# 重新加载 systemd
sudo systemctl daemon-reload

# 启用服务（开机自启）
sudo systemctl enable xiaohongshu-backend
sudo systemctl enable xiaohongshu-frontend

# 启动服务
sudo systemctl start xiaohongshu-backend
sudo systemctl start xiaohongshu-frontend

# 查看状态
sudo systemctl status xiaohongshu-backend
sudo systemctl status xiaohongshu-frontend

# 查看日志
sudo journalctl -u xiaohongshu-backend -f
sudo journalctl -u xiaohongshu-frontend -f

# 停止服务
sudo systemctl stop xiaohongshu-backend
sudo systemctl stop xiaohongshu-frontend
```

---

## 配置指南

### API 密钥获取指南

#### Google Gemini API

1. 访问 [Google AI Studio](https://aistudio.google.com)
2. 点击 "Get API Key"
3. 创建新的 API 密钥
4. 复制密钥到配置文件

```yaml
gemini:
  type: google_gemini
  api_key: AIzaxxxxxxxxxxxxxxxxxxxxxxxxx
  model: gemini-2.0-flash
```

#### OpenAI API

1. 访问 [OpenAI 平台](https://platform.openai.com)
2. 登录或注册账号
3. 在 API keys 页面创建新密钥
4. 复制密钥到配置文件

```yaml
openai:
  type: openai_compatible
  api_key: sk-xxxxxxxxxxxxxxxxxxxx
  base_url: https://api.openai.com/v1
  model: gpt-4o
```

### 环境变量配置

#### 创建 .env 文件（可选，用于敏感信息）

```bash
# .env
FLASK_DEBUG=True
FLASK_HOST=0.0.0.0
FLASK_PORT=12398
```

#### 加载环境变量

在 `backend/app.py` 中已经集成了环境变量支持（通过 python-dotenv）。

---

## 常见问题

### Q1: 运行 `uv sync` 报错 "command not found"

**解决方案**:
```bash
# 安装 uv
pip install uv

# 或使用官方安装脚本
curl -LsSf https://astral.sh/uv/install.sh | sh

# 添加到 PATH
export PATH="$HOME/.cargo/bin:$PATH"
```

### Q2: 虚拟环境激活后，`python` 命令找不到

**解决方案**:
```bash
# 确保虚拟环境已正确激活
# Linux/macOS
source venv/bin/activate

# Windows
venv\Scripts\activate.bat

# 验证激活
which python  # 应该显示虚拟环境的路径
```

### Q3: 前端无法连接到后端 API（跨域错误）

**可能原因**:
- 后端服务未启动
- CORS 配置不正确
- 防火墙阻止

**解决方案**:
```bash
# 1. 检查后端是否运行
curl http://localhost:12398/api/health

# 2. 检查前端配置中的 API 地址
# frontend/src/stores/api.ts
# 确保 BASE_URL 指向正确的后端地址

# 3. 如果在生产环境，可能需要调整 CORS 配置
# backend/app.py 中的 CORS_ORIGINS
```

### Q4: API Key 错误提示

**解决方案**:
```bash
# 1. 检查 API Key 是否正确
# text_providers.yaml 或 image_providers.yaml

# 2. 确保 API Key 有效且未过期

# 3. 检查 API 账号是否有配额

# 4. 在 Web 界面的设置页面重新输入 API Key
```

### Q5: 启动时找不到配置文件

**解决方案**:
```bash
# 复制配置文件
cp text_providers.yaml.example text_providers.yaml
cp image_providers.yaml.example image_providers.yaml

# 编辑配置文件
nano text_providers.yaml
nano image_providers.yaml
```

---

## 生产环境部署

### 生产环境检查清单

- [ ] Python 3.11+ 安装（使用官方包，不要用 conda）
- [ ] Node.js 18+ 安装
- [ ] pnpm 全局安装
- [ ] uv 全局安装
- [ ] 项目代码已克隆
- [ ] 虚拟环境已创建
- [ ] 依赖已安装（`uv sync`）
- [ ] 配置文件已编辑并验证
- [ ] API Key 已配置
- [ ] 防火墙规则已配置
- [ ] 日志目录已创建
- [ ] 备份计划已制定

### 生产环境部署步骤

#### 1. 系统准备

```bash
# 创建应用用户
sudo useradd -m -s /bin/bash xiaohongshu

# 创建项目目录
sudo mkdir -p /opt/xiaohongshu
sudo chown xiaohongshu:xiaohongshu /opt/xiaohongshu

# 创建日志目录
sudo mkdir -p /var/log/xiaohongshu
sudo chown xiaohongshu:xiaohongshu /var/log/xiaohongshu

# 创建数据目录
sudo mkdir -p /var/lib/xiaohongshu/{output,history}
sudo chown -R xiaohongshu:xiaohongshu /var/lib/xiaohongshu
```

#### 2. 项目部署

```bash
# 切换到应用用户
sudo su - xiaohongshu

# 克隆项目
cd /opt/xiaohongshu
git clone https://github.com/HisMax/RedInk.git
cd RedInk

# 创建虚拟环境
python3 -m venv venv
source venv/bin/activate

# 安装依赖
uv sync

# 前端构建（生产版本）
cd frontend
pnpm install --frozen-lockfile
pnpm build  # 生成 dist/ 目录
cd ..
```

#### 3. 配置生产环境

```bash
# 复制配置文件
cp text_providers.yaml.example text_providers.yaml
cp image_providers.yaml.example image_providers.yaml

# 编辑配置（使用生产级 API Key）
nano text_providers.yaml
nano image_providers.yaml

# 创建 .env 生产环境文件
cat > .env.production << 'EOF'
FLASK_DEBUG=False
FLASK_HOST=0.0.0.0
FLASK_PORT=12398
FLASK_ENV=production
EOF
```

#### 4. Nginx 反向代理配置

创建 `/etc/nginx/sites-available/xiaohongshu`:

```nginx
upstream backend {
    server localhost:12398;
}

upstream frontend_dev {
    server localhost:5173;
}

server {
    listen 80;
    listen [::]:80;
    server_name your-domain.com www.your-domain.com;

    # 前端
    location / {
        proxy_pass http://frontend_dev;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        
        # WebSocket 支持
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # 后端 API
    location /api/ {
        proxy_pass http://backend;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # 上传文件大小限制
        client_max_body_size 50M;
        
        # 超时设置（图片生成可能耗时）
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 300s;
    }

    # 静态文件缓存
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 30d;
        add_header Cache-Control "public, immutable";
    }

    # 日志
    access_log /var/log/nginx/xiaohongshu_access.log;
    error_log /var/log/nginx/xiaohongshu_error.log;
}

# HTTPS 配置（可选，使用 Let's Encrypt）
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name your-domain.com www.your-domain.com;

    ssl_certificate /etc/letsencrypt/live/your-domain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/your-domain.com/privkey.pem;

    # ... 其他配置同上 ...
}

# HTTP 重定向到 HTTPS
server {
    listen 80;
    listen [::]:80;
    server_name your-domain.com www.your-domain.com;
    return 301 https://$server_name$request_uri;
}
```

启用 Nginx 配置:

```bash
# 创建软链接
sudo ln -s /etc/nginx/sites-available/xiaohongshu /etc/nginx/sites-enabled/

# 测试配置
sudo nginx -t

# 重启 Nginx
sudo systemctl restart nginx
```

#### 5. SSL 证书（使用 Let's Encrypt）

```bash
# 安装 Certbot
sudo apt install certbot python3-certbot-nginx

# 获取证书
sudo certbot certonly --nginx -d your-domain.com -d www.your-domain.com

# 自动续期
sudo systemctl enable certbot.timer
sudo systemctl start certbot.timer
```

#### 6. 启动生产服务

```bash
# 启动后端
sudo systemctl start xiaohongshu-backend

# 启动前端
sudo systemctl start xiaohongshu-frontend

# 查看状态
sudo systemctl status xiaohongshu-backend xiaohongshu-frontend

# 查看日志
sudo journalctl -u xiaohongshu-backend -f
```

### 性能优化

#### 1. 图片生成并发设置

根据 API 配额调整 `high_concurrency` 参数：

```yaml
# 低配额/试用账号
high_concurrency: false

# 付费账号/高配额
high_concurrency: true
```

#### 2. 内存优化

```bash
# 限制 Flask 进程内存
ulimit -m 2097152  # 2GB

# 在 systemd 中设置
[Service]
MemoryLimit=2G
```

#### 3. 日志轮转

创建 `/etc/logrotate.d/xiaohongshu`:

```
/var/log/xiaohongshu/*.log {
    daily
    missingok
    rotate 14
    compress
    delaycompress
    notifempty
    create 0640 xiaohongshu xiaohongshu
    sharedscripts
    postrotate
        systemctl reload xiaohongshu-backend xiaohongshu-frontend > /dev/null 2>&1 || true
    endscript
}
```

---

## 故障排查

### 启动日志分析

#### 查看后端日志

```bash
# 查看实时日志
tail -f backend.log

# 查看最后 100 行
tail -100 backend.log

# 搜索错误
grep -i error backend.log
```

#### 查看前端日志

```bash
# 查看实时日志
tail -f frontend.log

# 搜索错误
grep -i error frontend.log
```

### 常见错误信息解决

#### 1. `ModuleNotFoundError: No module named 'backend'`

```bash
# 原因：虚拟环境未激活或 Python 路径错误

# 解决方案
source venv/bin/activate
uv sync
```

#### 2. `Address already in use`

```bash
# 原因：端口被占用

# 查找占用端口的进程
lsof -i :12398  # 后端
lsof -i :5173   # 前端

# 杀死进程
kill -9 <PID>

# 或更改端口号（在 backend/config.py 中修改）
```

#### 3. `ConnectionError: Failed to connect to API`

```bash
# 原因：网络连接问题或 API 不可达

# 检查网络
ping -c 4 8.8.8.8

# 测试 API 连接
curl -v https://api.openai.com/v1/models

# 检查代理设置
env | grep -i proxy
```

#### 4. `InvalidApiKeyError`

```bash
# 原因：API Key 无效或过期

# 解决方案
# 1. 验证 API Key
# 2. 在控制台测试 API Key
# 3. 重新在 Web 界面输入
# 4. 检查 API 配额
```

### 性能问题

#### 问题：图片生成缓慢

```bash
# 原因可能：
# 1. API 限流
# 2. 网络延迟
# 3. 高并发未启用

# 解决方案
# 1. 启用 high_concurrency（如果 API 支持）
# 2. 减少生成页数
# 3. 使用更快的 API 服务商
```

#### 问题：内存占用过高

```bash
# 监控内存使用
top -b -n 1 | grep -E "VIRT|RES"

# 减少并发数量
# 在 image_providers.yaml 中设置 high_concurrency: false
```

### 调试技巧

#### 1. 启用详细日志

```bash
# 修改 backend/config.py
DEBUG = True

# 重启后端服务
# 查看详细的错误信息
```

#### 2. API 测试

```bash
# 测试后端健康状态
curl http://localhost:12398/api/health

# 测试 API 端点
curl -X POST http://localhost:12398/api/outline \
  -H "Content-Type: application/json" \
  -d '{"topic": "测试"}'
```

#### 3. 虚拟环境诊断

```bash
# 显示 Python 路径
python -c "import sys; print('\n'.join(sys.path))"

# 显示已安装的包
pip list

# 检查包版本
pip show flask
```

---

## 工作流总结

### 日常开发流程

```bash
# 1. 进入项目目录
cd ~/RedInk

# 2. 激活虚拟环境
source venv/bin/activate

# 3. 启动后端
uv run python -m backend.app &

# 4. 启动前端（新终端）
cd frontend
pnpm dev

# 5. 访问应用
# http://localhost:5173

# 6. 开发和测试
# ... 修改代码 ...

# 7. 停止服务
# Ctrl+C 停止前端和后端
```

### 部署流程

```bash
# 1. 准备生产环境
# ... 按照生产环境部署步骤 ...

# 2. 构建前端
cd frontend
pnpm build

# 3. 配置 Nginx 反向代理
# ... 配置 nginx.conf ...

# 4. 启动 systemd 服务
sudo systemctl start xiaohongshu-backend
sudo systemctl start xiaohongshu-frontend

# 5. 验证部署
# curl https://your-domain.com/api/health
```

---

## 相关资源

- [Python venv 官方文档](https://docs.python.org/3/library/venv.html)
- [Flask 官方文档](https://flask.palletsprojects.com/)
- [Vue 3 官方文档](https://vuejs.org/)
- [uv 包管理器文档](https://docs.astral.sh/uv/)
- [pnpm 官方文档](https://pnpm.io/)

---

## 获取帮助

如遇到问题，请：

1. 查看 [常见问题](#常见问题) 和 [故障排查](#故障排查) 部分
2. 查看应用日志文件
3. 在 [GitHub Issues](https://github.com/HisMax/RedInk/issues) 提交问题
4. 联系作者：histonemax@gmail.com

---

**最后更新**: 2024年11月
**版本**: 1.0.0
