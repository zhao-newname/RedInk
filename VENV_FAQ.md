# venv 部署常见问题解答

---

## 环境安装相关

### Q: 如何检查我的 Python 版本？
**A:**
```bash
python3 --version
# 或
python --version

# 确保版本 >= 3.11
```

### Q: 如何安装 Python 3.11？

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install python3.11 python3.11-venv python3.11-dev
```

**CentOS/RHEL:**
```bash
sudo yum install python3.11 python3.11-devel
```

**macOS:**
```bash
brew install python@3.11
# 或使用 pyenv
brew install pyenv
pyenv install 3.11.5
pyenv local 3.11.5
```

**Windows:**
- 下载安装程序: [python.org](https://www.python.org/downloads/)
- 或使用 Windows Package Manager: `winget install Python.Python.3.11`

### Q: 如何安装 uv 包管理器？

**推荐方式（macOS/Linux）:**
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh

# 添加到 PATH
export PATH="$HOME/.cargo/bin:$PATH"
```

**使用 pip 安装:**
```bash
pip install uv
```

**Windows (PowerShell):**
```bash
powershell -c "irm https://astral.sh/uv/install.ps1 | iex"
```

### Q: 如何验证 pnpm 是否正确安装？

```bash
pnpm --version
npm list -g pnpm
```

### Q: pnpm 安装失败怎么办？

```bash
# 卸载重装
npm uninstall -g pnpm

# 使用 npm 最新版本重新安装
npm install -g pnpm@latest

# 或使用其他包管理器
brew install pnpm  # macOS

# Windows (PowerShell)
iwr https://get.pnpm.io -useb | iex
```

---

## 虚拟环境相关

### Q: 如何创建虚拟环境？

```bash
python3 -m venv venv
```

### Q: 如何激活虚拟环境？

**Linux/macOS:**
```bash
source venv/bin/activate
# 提示符会变为 (venv) ...
```

**Windows (CMD):**
```bash
venv\Scripts\activate.bat
```

**Windows (PowerShell):**
```bash
venv\Scripts\Activate.ps1
# 如果遇到执行策略错误:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Q: 如何检查虚拟环境是否已激活？

```bash
# 激活后，提示符前会显示 (venv)
(venv) user@host:~/RedInk$

# 或检查 Python 路径
which python  # Linux/macOS，应该显示 venv/bin/python

# Windows 检查：
where python  # 应该显示 venv\Scripts\python.exe
```

### Q: 如何停用虚拟环境？

```bash
deactivate
# 提示符会恢复到正常
```

### Q: 虚拟环境可以删除吗？

```bash
# 可以，直接删除 venv 目录
rm -rf venv  # Linux/macOS
rmdir /s venv  # Windows

# 需要时可以重新创建
python3 -m venv venv
```

### Q: 如何在不同的 Python 版本间切换？

```bash
# 使用 pyenv（推荐）
pyenv global 3.11.5
python -m venv venv

# 或指定 Python 版本创建虚拟环境
python3.11 -m venv venv
python3.12 -m venv venv_py312
```

---

## 依赖安装相关

### Q: `uv sync` 报错 "command not found"？

```bash
# 安装 uv
pip install uv

# 如果还是找不到，在虚拟环境中重新安装
source venv/bin/activate
pip install uv
```

### Q: `uv sync` 很慢怎么办？

```bash
# 1. 检查网络连接
ping -c 4 8.8.8.8

# 2. 使用国内镜像（如果在中国）
# 编辑 ~/.config/uv/uv.toml（如果不存在则创建）
[pip]
index-url = "https://pypi.tsinghua.edu.cn/simple"

# 3. 尝试清除缓存后重新同步
rm -rf .uv_cache
uv sync
```

### Q: 依赖安装失败，显示 "Permission denied"？

```bash
# 确保虚拟环境已激活
source venv/bin/activate

# 使用 --user 标志（仅在虚拟环境外）
pip install --user package_name

# 或检查目录权限
ls -la venv/
```

### Q: 前端依赖 `pnpm install` 报错？

```bash
# 1. 清除缓存
rm -rf node_modules
rm pnpm-lock.yaml  # 谨慎操作

# 2. 清除 pnpm 缓存
pnpm store prune

# 3. 重新安装
pnpm install

# 4. 或使用 --frozen-lockfile（严格模式）
pnpm install --frozen-lockfile
```

### Q: 如何验证依赖是否正确安装？

```bash
# 列出已安装的包
pip list

# 查看特定包
pip show flask

# 检查前端依赖
pnpm list
```

---

## 配置文件相关

### Q: 配置文件在哪里？

```
项目根目录/
├── text_providers.yaml        # 文本生成配置
├── image_providers.yaml       # 图片生成配置
└── .env (可选)                # 环境变量

frontend/
└── src/
    └── config.ts              # 前端配置
```

### Q: 如何从示例创建配置文件？

```bash
cp text_providers.yaml.example text_providers.yaml
cp image_providers.yaml.example image_providers.yaml
```

### Q: 如何获取 API Key？

#### Google Gemini
1. 访问 [Google AI Studio](https://aistudio.google.com)
2. 点击 "Get API Key"
3. 选择或创建项目
4. 复制 API Key
5. 粘贴到配置文件

#### OpenAI
1. 访问 [OpenAI Platform](https://platform.openai.com)
2. 登录账号
3. 进入 "API keys" 页面
4. 点击 "Create new secret key"
5. 复制密钥
6. 粘贴到配置文件

#### 其他服务商
- 参考各服务商官方文档

### Q: API Key 的正确格式是什么？

```yaml
# Google Gemini / Vertex AI
api_key: AIzaxxxxxxxxxxxxxxxxxxxxxxxxx

# OpenAI
api_key: sk-xxxxxxxxxxxxxxxxxxxx

# 不要包含引号（YAML 会自动处理）
# ✗ api_key: "sk-xxxx"  错误
# ✓ api_key: sk-xxxx    正确
```

### Q: 如何验证配置文件的正确性？

```bash
# 使用 Python 验证 YAML 语法
python3 -c "import yaml; yaml.safe_load(open('text_providers.yaml'))"

# 如果没有输出，说明语法正确
```

### Q: 配置文件改了为什么没有生效？

```bash
# 1. 重启后端服务
bash venv-start.sh restart

# 2. 或手动重启
# Ctrl+C 停止后端
# 重新运行 uv run python -m backend.app
```

### Q: 如何在 Web 界面中修改配置？

1. 访问 http://localhost:5173/settings
2. 选择要配置的 API 服务
3. 填入 API Key 和其他参数
4. 点击保存
5. 配置会自动保存到 YAML 文件

---

## 启动和运行相关

### Q: 如何启动后端和前端？

**使用启动脚本（推荐）:**
```bash
bash venv-start.sh start
```

**手动启动:**
```bash
# 激活虚拟环境
source venv/bin/activate

# 终端 1: 启动后端
uv run python -m backend.app

# 终端 2: 启动前端
cd frontend
pnpm dev
```

### Q: 后端和前端各自的地址是什么？

- **前端**: http://localhost:5173
- **后端**: http://localhost:12398
- **后端 API**: http://localhost:12398/api/*

### Q: 如何让服务在后台运行？

```bash
# 使用 nohup（不挂起）
nohup uv run python -m backend.app > backend.log 2>&1 &
cd frontend && nohup pnpm dev > ../frontend.log 2>&1 &

# 或使用启动脚本
bash venv-start.sh start

# 查看后台进程
jobs
ps aux | grep python
ps aux | grep node
```

### Q: 如何停止运行的服务？

```bash
# 使用启动脚本
bash venv-start.sh stop

# 或手动停止
# 在启动的终端中按 Ctrl+C

# 或使用 kill 命令
kill -9 $(lsof -t -i :12398)  # 停止后端
kill -9 $(lsof -t -i :5173)   # 停止前端
```

### Q: 启动时显示 "Address already in use"？

```bash
# 原因：端口被占用

# 查找占用端口的进程
lsof -i :12398  # 后端
lsof -i :5173   # 前端

# 杀死进程
kill -9 <PID>

# 或更改端口（在 backend/config.py 中修改）
```

### Q: 如何使用不同的端口？

**后端端口:**
```python
# 修改 backend/config.py
PORT = 12398  # 改为其他端口

# 或使用环境变量（如果支持）
export FLASK_PORT=8080
```

**前端端口:**
```typescript
// 修改 frontend/vite.config.ts
server: {
  port: 5173  // 改为其他端口
}
```

### Q: 如何让服务开机自启？

#### Linux (systemd)

创建 `/etc/systemd/system/xiaohongshu-backend.service`:
```ini
[Unit]
Description=RedInk Backend Service
After=network.target

[Service]
Type=simple
User=username
WorkingDirectory=/home/username/RedInk
Environment="PATH=/home/username/RedInk/venv/bin"
ExecStart=/home/username/RedInk/venv/bin/python -m backend.app
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

启用服务：
```bash
sudo systemctl daemon-reload
sudo systemctl enable xiaohongshu-backend
sudo systemctl start xiaohongshu-backend
```

#### macOS (LaunchAgent)

创建 `~/Library/LaunchAgents/com.xiaohongshu.backend.plist`（较复杂，建议查看详细指南）

#### Windows (任务计划程序)

1. 打开任务计划程序
2. 创建基本任务
3. 设置触发条件为"系统启动时"
4. 设置操作为运行启动脚本

---

## 错误排查相关

### Q: 启动时显示 "ModuleNotFoundError: No module named 'backend'"？

**原因:** Python 路径配置错误或虚拟环境未激活

```bash
# 解决方案
source venv/bin/activate
uv sync

# 重新启动
uv run python -m backend.app
```

### Q: 前端无法连接到后端 API？

**检查清单:**
```bash
# 1. 后端是否运行
curl http://localhost:12398/api/health

# 2. 检查防火墙
sudo ufw allow 12398  # Ubuntu

# 3. 检查 CORS 配置
# 后端应该允许来自前端的请求

# 4. 检查前端 API 地址配置
# frontend/src/stores/api.ts 中的 BASE_URL
```

### Q: API Key 报错 "Invalid API Key"？

```bash
# 检查清单
# 1. API Key 是否正确复制（无多余空格）
# 2. API Key 是否已激活（某些服务需要激活）
# 3. API Key 是否有配额限制
# 4. API 是否支持你选择的模型

# 测试 API
curl -H "Authorization: Bearer YOUR_API_KEY" https://api.example.com/models
```

### Q: 图片生成失败或超时？

```bash
# 检查清单
# 1. 网络连接是否正常
# 2. API 配额是否已用完
# 3. 是否启用了高并发（GCP 试用账号不建议）
# 4. 图片大小是否过大

# 禁用高并发
# 编辑 image_providers.yaml
high_concurrency: false
```

### Q: 日志中显示大量错误，怎么办？

```bash
# 查看详细日志
bash venv-start.sh logs

# 或单独查看
tail -100 backend.log
tail -100 frontend.log

# 搜索特定错误
grep -i error backend.log
grep -i warning backend.log
```

### Q: 内存占用过高怎么办？

```bash
# 监控内存使用
top -b -n 1 | head -20

# 减少并发数量
# 在 image_providers.yaml 中设置 high_concurrency: false

# 重启服务
bash venv-start.sh restart

# 清理缓存
rm -rf output/*  # 谨慎操作
```

---

## 部署和上线相关

### Q: 如何部署到生产服务器？

参考 [VENV_DEPLOYMENT_GUIDE.md - 生产环境部署](./VENV_DEPLOYMENT_GUIDE.md#生产环境部署)

基本步骤：
1. 创建应用用户
2. 克隆项目
3. 创建虚拟环境
4. 安装依赖
5. 配置 API Key
6. 配置 Nginx 反向代理
7. 设置 systemd 服务
8. 配置 SSL 证书

### Q: 如何配置 Nginx 反向代理？

参考 [VENV_DEPLOYMENT_GUIDE.md - Nginx 配置](./VENV_DEPLOYMENT_GUIDE.md#4-nginx-反向代理配置)

基本配置：
```nginx
upstream backend {
    server localhost:12398;
}

server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://backend;
        proxy_set_header Host $host;
    }

    location /api/ {
        proxy_pass http://backend;
    }
}
```

### Q: 如何配置 SSL 证书？

```bash
# 使用 Let's Encrypt（免费）
sudo apt install certbot python3-certbot-nginx

# 申请证书
sudo certbot certonly --nginx -d your-domain.com

# 更新 Nginx 配置，添加 SSL
listen 443 ssl;
ssl_certificate /etc/letsencrypt/live/your-domain.com/fullchain.pem;
ssl_certificate_key /etc/letsencrypt/live/your-domain.com/privkey.pem;
```

### Q: 如何实现 CI/CD 部署？

基本流程：
1. 推送代码到 GitHub
2. GitHub Actions 自动运行测试
3. 部署脚本拉取最新代码
4. 自动重启服务

```bash
#!/bin/bash
# deploy.sh
cd /opt/xiaohongshu
git pull
source venv/bin/activate
uv sync
cd frontend && pnpm install && cd ..
sudo systemctl restart xiaohongshu-backend
sudo systemctl restart xiaohongshu-frontend
```

---

## 性能优化相关

### Q: 如何提高图片生成速度？

1. **启用高并发**
   ```yaml
   high_concurrency: true  # 如果 API 支持
   ```

2. **使用更快的 API**
   - OpenAI DALL-E 通常比 Gemini 快
   - 但费用更高

3. **减少生成页数**
   - 在前端设置中减少最大页数

4. **使用更好的服务器**
   - 提高 CPU 和内存

### Q: 如何优化内存使用？

```bash
# 在 systemd 中限制内存
[Service]
MemoryLimit=2G

# 定期清理缓存
rm -rf output/*_temp
rm -rf history/*
```

### Q: 如何监控服务状态？

```bash
# 使用启动脚本
bash venv-start.sh status

# 使用系统工具
top
htop
systemctl status xiaohongshu-backend
journalctl -u xiaohongshu-backend -f
```

---

## 更新和维护相关

### Q: 如何更新项目代码？

```bash
cd ~/RedInk
git pull origin main

# 如果依赖有变化
source venv/bin/activate
uv sync
cd frontend && pnpm install && cd ..

# 重启服务
bash venv-start.sh restart
```

### Q: 如何备份数据？

```bash
# 备份生成的图片
cp -r output ~/backup/output_$(date +%Y%m%d)

# 备份历史记录
cp -r history ~/backup/history_$(date +%Y%m%d)

# 备份配置文件
cp *.yaml ~/backup/
```

### Q: 如何回滚到上一个版本？

```bash
# 查看提交历史
git log --oneline

# 回滚到特定版本
git checkout <commit-hash>

# 重新启动
bash venv-start.sh restart
```

---

## 其他问题

### Q: 如何在 Windows 上开发？

```bash
# 推荐使用 Windows Terminal
# 1. 安装 Python 3.11+
# 2. 按照快速开始步骤操作
# 3. 使用 venv-start.bat 脚本

venv-start.bat setup
venv-start.bat start
```

### Q: 如何在 WSL2 上开发？

```bash
# WSL2 中的操作与 Linux 相同
wsl --install
# 进入 WSL2
wsl

# 按照 Linux 步骤操作
bash venv-start.sh setup
bash venv-start.sh start
```

### Q: 如何共享开发环境给团队？

1. 推送代码到 GitHub
2. 提供项目 README 和部署指南
3. 每个开发者本地:
   ```bash
   git clone <repo>
   bash venv-start.sh setup
   bash venv-start.sh start
   ```

### Q: 如何贡献代码？

1. Fork 项目
2. 创建特性分支
3. 提交变更
4. 发送 Pull Request

更多信息见 README.md 的贡献部分。

---

## 获取更多帮助

- **完整部署指南**: [VENV_DEPLOYMENT_GUIDE.md](./VENV_DEPLOYMENT_GUIDE.md)
- **快速开始**: [VENV_QUICKSTART.md](./VENV_QUICKSTART.md)
- **导航中心**: [VENV_INDEX.md](./VENV_INDEX.md)
- **GitHub Issues**: [https://github.com/HisMax/RedInk/issues](https://github.com/HisMax/RedInk/issues)
- **联系作者**: histonemax@gmail.com

---

**最后更新**: 2024年11月
**版本**: 1.0.0
