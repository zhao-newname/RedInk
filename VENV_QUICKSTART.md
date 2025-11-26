# venv 快速开始 - 3分钟上手

> 最快速的 venv 环境部署指南

## 前置要求

```bash
# 检查 Python (需要 3.11+)
python3 --version

# 检查 Node.js (需要 18+)
node --version

# 安装 pnpm
npm install -g pnpm

# 安装 uv
pip install uv
```

---

## 一句话快速部署

```bash
git clone https://github.com/HisMax/RedInk.git && cd RedInk && \
python3 -m venv venv && source venv/bin/activate && \
uv sync && cp text_providers.yaml.example text_providers.yaml && \
cp image_providers.yaml.example image_providers.yaml && \
echo "✓ 环境准备完成！请编辑配置文件后启动服务"
```

---

## 完整 5 分钟部署

### 1️⃣ 克隆项目
```bash
git clone https://github.com/HisMax/RedInk.git
cd RedInk
```

### 2️⃣ 创建虚拟环境
```bash
python3 -m venv venv
source venv/bin/activate  # Linux/macOS
# 或
venv\Scripts\activate     # Windows
```

### 3️⃣ 安装依赖
```bash
uv sync                    # 后端
cd frontend && pnpm install && cd ..  # 前端
```

### 4️⃣ 配置 API
```bash
cp text_providers.yaml.example text_providers.yaml
cp image_providers.yaml.example image_providers.yaml
# 编辑文件，填入 API Key
nano text_providers.yaml
nano image_providers.yaml
```

### 5️⃣ 启动服务

**终端 1 - 后端**:
```bash
source venv/bin/activate
uv run python -m backend.app
```

**终端 2 - 前端**:
```bash
cd frontend
pnpm dev
```

### 6️⃣ 访问应用
```
浏览器打开: http://localhost:5173
```

---

## 常用命令速查

| 命令 | 说明 |
|------|------|
| `source venv/bin/activate` | 激活虚拟环境 (Linux/macOS) |
| `venv\Scripts\activate` | 激活虚拟环境 (Windows) |
| `uv sync` | 同步后端依赖 |
| `uv run python -m backend.app` | 启动后端 (12398 端口) |
| `pnpm install` | 安装前端依赖 |
| `pnpm dev` | 启动前端 (5173 端口) |
| `pnpm build` | 生产构建 |
| `deactivate` | 停用虚拟环境 |

---

## 配置 API Key (极简版)

### Google Gemini
1. 访问 [aistudio.google.com](https://aistudio.google.com)
2. 点击 "Get API Key"
3. 复制到 `text_providers.yaml` 和 `image_providers.yaml`

### OpenAI
1. 访问 [platform.openai.com](https://platform.openai.com)
2. 在 API keys 中创建密钥
3. 复制到配置文件

```yaml
# text_providers.yaml
active_provider: gemini
providers:
  gemini:
    type: google_gemini
    api_key: AIzaxxxxxxxxxxxxxxxxx  # 填入你的 API Key
    model: gemini-2.0-flash

# image_providers.yaml
active_provider: gemini
providers:
  gemini:
    type: google_genai
    api_key: AIzaxxxxxxxxxxxxxxxxx  # 同一个 Key
    model: gemini-3-pro-image-preview
    high_concurrency: false
```

---

## 快速故障排查

| 问题 | 解决方案 |
|------|----------|
| `command not found: uv` | `pip install uv` |
| `ModuleNotFoundError` | `source venv/bin/activate && uv sync` |
| 无法连接到 API | 检查 API Key 和网络连接 |
| 端口被占用 | `lsof -i :12398` 查找进程，`kill -9 PID` 杀死 |
| CORS 错误 | 确保后端正在运行 |

---

## 一键启动脚本 (Linux/macOS)

保存为 `quick-start.sh`:

```bash
#!/bin/bash
source venv/bin/activate
uv run python -m backend.app > backend.log 2>&1 &
cd frontend && pnpm dev > ../frontend.log 2>&1 &
echo "✓ 后端: http://localhost:12398"
echo "✓ 前端: http://localhost:5173"
echo "✓ 查看日志: tail -f backend.log"
```

使用:
```bash
chmod +x quick-start.sh
./quick-start.sh
```

---

## 部署到服务器

```bash
# SSH 登录服务器
ssh user@server.com

# 重复以上 5 分钟部署步骤
git clone https://github.com/HisMax/RedInk.git
cd RedInk
python3 -m venv venv
source venv/bin/activate
uv sync
cd frontend && pnpm install && cd ..
cp *.example *.yaml
# 编辑配置文件
nano text_providers.yaml
nano image_providers.yaml

# 启动（后台运行）
nohup uv run python -m backend.app > backend.log 2>&1 &
cd frontend && nohup pnpm dev > ../frontend.log 2>&1 &
```

---

## 下一步

- 📖 详细指南：[VENV_DEPLOYMENT_GUIDE.md](./VENV_DEPLOYMENT_GUIDE.md)
- 🐳 Docker 版本：[DOCKER_INDEX.md](./DOCKER_INDEX.md)（如有）
- 🆘 遇到问题：查看故障排查部分或提交 Issue

**享受使用红墨！** ✨
