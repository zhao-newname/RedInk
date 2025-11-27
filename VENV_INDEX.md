# venv 部署文档 - 快速导航

> 选择合适的部署指南开始您的红墨之旅

---

## 📚 文档导航

### 🚀 快速开始（3-5分钟）

**推荐首先阅读**

- **[VENV_QUICKSTART.md](./VENV_QUICKSTART.md)** - 快速开始指南
  - 3分钟一句话部署
  - 5分钟完整部署
  - 常用命令速查表
  - 快速故障排查

---

### 📖 详细指南（30分钟）

**全面了解所有细节**

- **[VENV_DEPLOYMENT_GUIDE.md](./VENV_DEPLOYMENT_GUIDE.md)** - 完整部署指南
  - ✅ 系统要求检查
  - ✅ Python/Node.js 安装
  - ✅ 虚拟环境配置
  - ✅ 依赖安装详解
  - ✅ API 密钥获取指南
  - ✅ 启动方式（3种）
  - ✅ 生产环境部署
  - ✅ Nginx 配置示例
  - ✅ SSL 证书配置
  - ✅ 故障排查指南
  - ✅ 性能优化建议

---

### 🛠️ 启动脚本

**开箱即用的启动工具**

#### Linux / macOS

```bash
# 赋予执行权限
chmod +x venv-start.sh

# 查看帮助
bash venv-start.sh help

# 快速启动
bash venv-start.sh start

# 查看日志
bash venv-start.sh logs

# 停止服务
bash venv-start.sh stop
```

**可用命令:**
- `bash venv-start.sh setup` - 首次环境设置（检查依赖、创建虚拟环境）
- `bash venv-start.sh start` - 启动所有服务
- `bash venv-start.sh stop` - 停止所有服务
- `bash venv-start.sh restart` - 重启所有服务
- `bash venv-start.sh logs` - 查看实时日志
- `bash venv-start.sh status` - 查看服务状态
- `bash venv-start.sh shell` - 进入虚拟环境 shell
- `bash venv-start.sh clean` - 清理日志文件

#### Windows

```bash
# 直接运行
venv-start.bat

# 或指定命令
venv-start.bat start
venv-start.bat stop
venv-start.bat setup
venv-start.bat status
```

---

## 🎯 按场景选择

### 场景 1️⃣ : 本地开发

**适合**: 开发者、测试人员

```bash
# 快速部署
bash venv-start.sh setup
bash venv-start.sh start

# 或按照 VENV_QUICKSTART.md 手动部署
```

**推荐阅读:**
- [VENV_QUICKSTART.md](./VENV_QUICKSTART.md) - 5分钟快速上手
- [VENV_DEPLOYMENT_GUIDE.md - 启动服务](./VENV_DEPLOYMENT_GUIDE.md#启动服务)

---

### 场景 2️⃣ : 服务器部署（不使用 Docker）

**适合**: Linux/Ubuntu 服务器部署

**部署步骤:**

1. 连接到服务器
   ```bash
   ssh user@server.com
   ```

2. 克隆项目
   ```bash
   git clone https://github.com/HisMax/RedInk.git
   cd RedInk
   ```

3. 运行初始化脚本
   ```bash
   bash venv-start.sh setup
   ```

4. 编辑配置文件
   ```bash
   nano text_providers.yaml
   nano image_providers.yaml
   ```

5. 启动服务
   ```bash
   bash venv-start.sh start
   ```

6. 配置反向代理（Nginx）
   - 查看 [VENV_DEPLOYMENT_GUIDE.md - Nginx 配置](./VENV_DEPLOYMENT_GUIDE.md#4-nginx-反向代理配置)

**推荐阅读:**
- [VENV_DEPLOYMENT_GUIDE.md - 生产环境部署](./VENV_DEPLOYMENT_GUIDE.md#生产环境部署)
- [VENV_DEPLOYMENT_GUIDE.md - Nginx 反向代理](./VENV_DEPLOYMENT_GUIDE.md#4-nginx-反向代理配置)

---

### 场景 3️⃣ : 现有项目升级

**适合**: 已有旧版本的用户

```bash
# 1. 更新代码
git pull origin main

# 2. 更新依赖
source venv/bin/activate
uv sync
cd frontend && pnpm install && cd ..

# 3. 重启服务
bash venv-start.sh restart
```

---

### 场景 4️⃣ : 故障排查

**遇到问题?**

1. 首先查看 [VENV_QUICKSTART.md - 快速故障排查](./VENV_QUICKSTART.md#快速故障排查)

2. 再查看 [VENV_DEPLOYMENT_GUIDE.md - 故障排查](./VENV_DEPLOYMENT_GUIDE.md#故障排查)

3. 查看服务状态
   ```bash
   bash venv-start.sh status
   ```

4. 查看日志
   ```bash
   bash venv-start.sh logs
   ```

---

## 📋 系统要求速查表

| 项目 | 要求 | 验证命令 |
|------|------|--------|
| Python | 3.11+ | `python3 --version` |
| Node.js | 18+ | `node --version` |
| pnpm | 最新 | `pnpm --version` |
| uv | 最新 | `uv --version` |
| 硬盘空间 | 5GB+ | `df -h` |
| 内存 | 2GB+ | `free -h` 或 `top` |

---

## ⚙️ 配置快速参考

### API 配置位置

```
项目根目录/
├── text_providers.yaml        ← 文本生成 API 配置
├── image_providers.yaml       ← 图片生成 API 配置
└── .env (可选)                ← 环境变量
```

### 常用配置

**Google Gemini** (推荐)
```yaml
active_provider: gemini
providers:
  gemini:
    type: google_gemini
    api_key: AIzaxxxxxxxxxxxxxxxxx
    model: gemini-2.0-flash
```

**OpenAI**
```yaml
active_provider: openai
providers:
  openai:
    type: openai_compatible
    api_key: sk-xxxxxxxxxxxxxxxxxxxx
    base_url: https://api.openai.com/v1
    model: gpt-4o
```

更多配置详见: [VENV_DEPLOYMENT_GUIDE.md - 配置指南](./VENV_DEPLOYMENT_GUIDE.md#配置指南)

---

## 🌐 访问地址

部署完成后，访问以下地址：

| 服务 | 地址 | 说明 |
|------|------|------|
| 前端应用 | http://localhost:5173 | 主要使用界面 |
| 后端 API | http://localhost:12398 | API 接口地址 |
| 后端文档 | http://localhost:12398/ | API 文档 |

### 生产环境

```
https://your-domain.com/          ← 前端
https://your-domain.com/api/      ← 后端 API
```

---

## 📱 命令备忘单

### 基础操作

```bash
# 环境设置
bash venv-start.sh setup

# 启动
bash venv-start.sh start

# 停止
bash venv-start.sh stop

# 查看状态
bash venv-start.sh status

# 查看日志
bash venv-start.sh logs

# 进入 shell
bash venv-start.sh shell
```

### 手动启动（不用脚本）

```bash
# 激活虚拟环境
source venv/bin/activate

# 安装依赖
uv sync
cd frontend && pnpm install && cd ..

# 终端 1: 启动后端
uv run python -m backend.app

# 终端 2: 启动前端
cd frontend
pnpm dev
```

---

## 🆘 获取帮助

### 遇到问题怎么办?

1. **查看文档**
   - [VENV_QUICKSTART.md - 快速故障排查](./VENV_QUICKSTART.md#快速故障排查)
   - [VENV_DEPLOYMENT_GUIDE.md - 故障排查](./VENV_DEPLOYMENT_GUIDE.md#故障排查)

2. **查看日志**
   ```bash
   bash venv-start.sh logs
   tail -f backend.log
   tail -f frontend.log
   ```

3. **检查状态**
   ```bash
   bash venv-start.sh status
   ```

4. **提交 Issue**
   - [GitHub Issues](https://github.com/HisMax/RedInk/issues)

5. **联系作者**
   - Email: histonemax@gmail.com
   - 微信: Histone2024

---

## 📚 文档列表

| 文件 | 大小 | 时间 | 用途 |
|------|------|------|------|
| [VENV_INDEX.md](./VENV_INDEX.md) | 📄 | 5分钟 | 📍 当前文件 - 导航 |
| [VENV_QUICKSTART.md](./VENV_QUICKSTART.md) | 📄 | 5分钟 | 🚀 快速开始 |
| [VENV_DEPLOYMENT_GUIDE.md](./VENV_DEPLOYMENT_GUIDE.md) | 📚 | 30分钟 | 📖 完整指南 |
| [venv-start.sh](./venv-start.sh) | 🛠️ | - | 🔧 启动脚本 (Linux/macOS) |
| [venv-start.bat](./venv-start.bat) | 🛠️ | - | 🔧 启动脚本 (Windows) |

---

## 🎓 学习路径

### 新手推荐

```
1. 阅读本文 (VENV_INDEX.md)
   ↓
2. 快速开始 (VENV_QUICKSTART.md)
   ↓
3. 运行启动脚本 (venv-start.sh / venv-start.bat)
   ↓
4. 访问应用 (http://localhost:5173)
   ↓
5. 如有问题，查看故障排查部分
```

### 进阶学习

```
1. 理解部署流程 (VENV_DEPLOYMENT_GUIDE.md 前半部分)
   ↓
2. 学习生产部署 (VENV_DEPLOYMENT_GUIDE.md - 生产环境部署)
   ↓
3. 配置 Nginx 反向代理
   ↓
4. 设置 SSL 证书
   ↓
5. 性能优化和监控
```

### 运维管理

```
1. 使用 systemd 管理服务
   ↓
2. 配置日志轮转
   ↓
3. 设置监控告警
   ↓
4. 制定备份计划
```

---

## 🔄 Docker vs venv

| 对比 | venv | Docker |
|------|------|--------|
| **学习曲线** | 低 ✅ | 中等 |
| **本地开发** | 优秀 ✅ | 好 |
| **生产部署** | 好 | 优秀 ✅ |
| **配置复杂度** | 低 ✅ | 低 ✅ |
| **资源占用** | 低 ✅ | 中等 |
| **跨平台** | 中等 | 优秀 ✅ |

**何时选择 venv:**
- ✅ 本地开发
- ✅ 学习 Python 和 Flask
- ✅ 共享服务器（多用户）
- ✅ 轻量级部署

**何时选择 Docker:**
- ✅ 生产环境
- ✅ 多服务器部署
- ✅ CI/CD 流程集成
- ✅ 需要隔离环境

---

## 💡 最佳实践

### 开发环境
```bash
# 每次开发前
source venv/bin/activate
git pull
uv sync  # 检查依赖更新
bash venv-start.sh start
```

### 生产环境
```bash
# 使用 systemd 服务管理
sudo systemctl start xiaohongshu-backend
sudo systemctl start xiaohongshu-frontend

# 定期检查日志
journalctl -u xiaohongshu-backend -f

# 定期备份数据
cp -r output history /backup/
```

### 安全建议
```bash
# 不要在代码中提交 API Key
# 使用 .env 文件（.gitignore 中排除）

# 定期更新依赖
uv sync

# 使用 HTTPS
# 配置 SSL 证书

# 限制 API 访问
# 配置防火墙规则
```

---

## 🎉 现在开始

### 选择您的路径：

- **🏃 急于开始？** → [VENV_QUICKSTART.md](./VENV_QUICKSTART.md)
- **📖 想要全面了解？** → [VENV_DEPLOYMENT_GUIDE.md](./VENV_DEPLOYMENT_GUIDE.md)
- **🛠️ 想用自动化脚本？** → 运行 `bash venv-start.sh setup`
- **❓ 遇到问题？** → 查看本文档的 [获取帮助](#获取帮助) 部分

---

**祝您部署顺利！如有任何问题，欢迎联系作者或提交 Issue。** ✨

**最后更新**: 2024年11月
**版本**: 1.0.0
