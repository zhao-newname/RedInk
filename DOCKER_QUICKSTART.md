# 🐳 Docker 快速开始指南

> 用 Docker 一键部署小红书图文生成器！

## ⚡ 5 分钟快速启动

### 步骤 1️⃣ 检查前置要求

```bash
# 检查 Docker
docker --version

# 检查 Docker Compose
docker-compose --version
```

如果未安装，请从 [docker.com](https://www.docker.com/products/docker-desktop) 下载安装。

### 步骤 2️⃣ 准备配置文件

**方式 A: 使用启动脚本（推荐）**

```bash
bash docker-start.sh start
```

脚本会自动检查并创建必要的配置文件。

**方式 B: 手动配置**

```bash
# 复制环境变量模板
cp .env.docker .env

# 编辑环境变量，填入 API Key
nano .env

# 复制图片服务商配置
cp image_providers.yaml.example config/image_providers.yaml
```

### 步骤 3️⃣ 填入 API Key

编辑 `.env` 文件，填入必需的 API Key：

```env
# Google Gemini API Key（必需）
GOOGLE_CLOUD_API_KEY=your_key_here

# 图片生成 API Key（必需）
IMAGE_API_KEY=your_key_here
```

获取 API Key：
- 🔗 [Google Gemini API](https://ai.google.dev/)
- 🔗 [图片生成服务](https://your-image-api.com)

### 步骤 4️⃣ 启动应用

**使用启动脚本：**

```bash
bash docker-start.sh start -d
```

**使用 Docker Compose：**

```bash
docker-compose up -d
```

**使用 Makefile：**

```bash
make docker-up
```

### 步骤 5️⃣ 验证应用

```bash
# 查看状态
docker-compose ps

# 查看日志
docker-compose logs -f

# 访问应用
# 在浏览器中打开: http://localhost:12398
```

看到以下信息表示成功：

```json
{
  "message": "红墨 AI图文生成器 API",
  "version": "0.1.0",
  "endpoints": {
    "health": "/api/health",
    "outline": "POST /api/outline",
    "generate": "POST /api/generate",
    "images": "GET /api/images/<filename>"
  }
}
```

✅ 完成！现在可以开始使用了。

---

## 📚 常用命令速查

### 启动 / 停止

```bash
# 启动应用
docker-compose up -d

# 停止应用
docker-compose down

# 重启应用
docker-compose restart
```

### 查看日志

```bash
# 查看所有日志
docker-compose logs

# 实时查看日志
docker-compose logs -f

# 查看最后 100 行
docker-compose logs --tail=100
```

### 进入容器

```bash
# 进入容器 shell
docker-compose exec xiaohongshu-app sh

# 执行单条命令
docker-compose exec xiaohongshu-app ls -la /app
```

### 查看状态

```bash
# 查看容器状态
docker-compose ps

# 查看资源使用
docker stats
```

### 清理

```bash
# 停止容器
docker-compose down

# 删除容器和卷
docker-compose down -v

# 清理未使用资源
docker system prune -a
```

---

## 🛠️ 使用脚本命令

`docker-start.sh` 脚本提供了交互式的启动方式：

```bash
# 显示帮助
bash docker-start.sh help

# 启动应用
bash docker-start.sh start -d

# 停止应用
bash docker-start.sh stop

# 重启应用
bash docker-start.sh restart -d

# 查看日志
bash docker-start.sh logs -f

# 进入容器 shell
bash docker-start.sh shell

# 检查应用健康状态
bash docker-start.sh health

# 重新构建
bash docker-start.sh rebuild -d

# 清理所有资源
bash docker-start.sh clean
```

---

## 📋 使用 Makefile 命令

项目包含 `Makefile` 以支持快捷命令：

```bash
# 初始化配置
make config-init

# 编辑配置
make config-edit

# 启动应用
make docker-up

# 停止应用
make docker-down

# 查看日志
make docker-logs

# 进入 shell
make docker-shell

# 查看状态
make docker-status

# 清理资源
make docker-clean

# 快捷别名
make up          # 同 make docker-up
make down        # 同 make docker-down
make logs        # 同 make docker-logs
make status      # 同 make docker-status
```

---

## ⚙️ 配置说明

### .env 环境变量

| 变量 | 说明 | 示例 |
|------|------|------|
| `GOOGLE_CLOUD_API_KEY` | Google Gemini API Key（必需） | `sk-...` |
| `IMAGE_API_KEY` | 图片生成 API Key（必需） | `api-...` |
| `TEXT_API_BASE_URL` | 文字生成服务地址 | `https://api.bltcy.ai` |
| `FLASK_DEBUG` | 调试模式（生产改为 False） | `False` |
| `DOCKER_PORT` | 映射到主机的端口 | `12398` |
| `CORS_ORIGINS` | 允许的跨域源 | `http://localhost:12398` |

### config/image_providers.yaml

选择一个图片生成服务商：

```yaml
# 修改这一行来切换服务商
active_provider: google_genai  # 可选: image_api, openai, custom 等
```

支持的服务商：
- ✅ `google_genai` - Google GenAI
- ✅ `image_api` - Image API
- ✅ `openai` - OpenAI DALL-E
- ✅ `duckcoding` - DuckCoding
- ✅ `custom` - 自定义服务

---

## 🚨 常见问题

### Q: 如何修改端口？

编辑 `.env` 文件：

```env
DOCKER_PORT=8080  # 改为你想要的端口
```

然后重新启动：

```bash
docker-compose down
docker-compose up -d
```

### Q: 如何查看生成的图片？

图片保存在 `./output/` 目录：

```bash
ls -la ./output/
```

### Q: 如何备份数据？

```bash
# 备份图片
cp -r ./output ./output.backup

# 备份历史记录
cp -r ./history ./history.backup
```

### Q: 如何在远程服务器上部署？

1. 将代码上传到服务器
2. 配置 `.env` 文件
3. 配置防火墙允许端口访问
4. 运行 `docker-compose up -d`

如果需要使用域名，配置反向代理（Nginx）：

```nginx
server {
    listen 80;
    server_name yourdomain.com;
    
    location / {
        proxy_pass http://localhost:12398;
    }
}
```

### Q: 如何重新构建镜像？

```bash
docker-compose down
docker-compose up -d --build
```

或使用脚本：

```bash
bash docker-start.sh rebuild -d
```

### Q: 如何查看实时日志？

```bash
docker-compose logs -f
```

或使用脚本：

```bash
bash docker-start.sh logs -f
```

---

## 📊 容器结构

```
┌─────────────────────────────────┐
│     Docker Container            │
├─────────────────────────────────┤
│  Frontend (Vue 3 + Vite)       │
│  - dist/ 静态文件              │
│  - 编译后的应用                 │
├─────────────────────────────────┤
│  Backend (Flask)               │
│  - Python 3.11                 │
│  - Flask 服务                  │
│  - 文案生成 + 图片生成         │
├─────────────────────────────────┤
│  Volumes (挂载点)              │
│  - /app/output → ./output      │
│  - /app/history → ./history    │
├─────────────────────────────────┤
│  Port: 12398 (可配置)          │
└─────────────────────────────────┘
```

---

## 🔐 安全建议

### 生产环境配置

```env
# 关闭调试模式
FLASK_DEBUG=False

# 限制 CORS 源
CORS_ORIGINS=https://yourdomain.com

# 限制端口为本机只
# docker-compose.yml:
#   ports:
#     - "127.0.0.1:12398:12398"
```

### API Key 管理

- ❌ 不要硬编码 API Key
- ❌ 不要提交 `.env` 到版本控制
- ✅ 使用环境变量或 Docker Secrets
- ✅ 定期轮换 API Key

---

## 📖 更多信息

详细文档请查看：

- 📘 [完整部署指南](./DOCKER_DEPLOYMENT.md)
- 📄 [项目 README](./README.md)
- 🐛 [故障排除](./DOCKER_DEPLOYMENT.md#-故障排除)

---

## 💡 提示

### 使用带颜色的启动脚本

脚本提供友好的交互式界面：

```bash
bash docker-start.sh
# 按照提示操作即可
```

### 组合命令

```bash
# 先清理，再构建，再启动
make docker-clean && make docker-build && make docker-up

# 或使用脚本
bash docker-start.sh rebuild -d && bash docker-start.sh health
```

### 监视应用

在另一个终端持续监视：

```bash
watch -n 2 docker-compose ps
```

---

## 🎉 现在可以开始了！

```bash
# 一键启动
bash docker-start.sh start -d

# 或
make docker-up

# 然后访问
# http://localhost:12398
```

祝你使用愉快！ 🚀

---

**需要帮助？**

- 查看日志：`docker-compose logs -f`
- 进入容器：`docker-compose exec xiaohongshu-app sh`
- 查看完整文档：`DOCKER_DEPLOYMENT.md`
