# Docker 部署指南

## 📋 项目结构

```
.
├── Dockerfile                 # Docker 镜像构建文件（多阶段构建）
├── docker-compose.yml         # Docker Compose 配置文件
├── .dockerignore             # Docker 构建时忽略的文件列表
├── .env.docker               # Docker 环境变量模板
├── config/
│   └── image_providers.yaml   # 图片生成服务商配置
├── backend/                   # Flask 后端代码
├── frontend/                  # Vue 前端代码
├── output/                    # 生成的图片输出目录（挂载点）
└── history/                   # 历史记录数据目录（挂载点）
```

## 🚀 快速开始

### 前置要求

- Docker >= 20.10
- Docker Compose >= 2.0
- 至少 2GB 可用磁盘空间

### 1. 克隆项目并进入目录

```bash
git clone <repository-url>
cd xiaohongshu-generator
```

### 2. 配置环境变量

复制 `.env.docker` 文件为 `.env`：

```bash
cp .env.docker .env
```

编辑 `.env` 文件，填入你的 API Key：

```bash
nano .env
# 或用其他编辑器，如 vim, code 等
```

**必需的配置项：**
- `GOOGLE_CLOUD_API_KEY` - Google Gemini API Key
- `IMAGE_API_KEY` - 图片生成服务 API Key

### 3. 配置图片生成服务商

编辑 `config/image_providers.yaml` 文件，选择你要使用的服务商：

```bash
nano config/image_providers.yaml
```

设置 `active_provider` 为你使用的服务商名称：
- `google_genai` - Google GenAI
- `image_api` - Image API（默认）
- `openai` - OpenAI DALL-E
- `duckcoding` - DuckCoding
- `custom` - 自定义服务商

### 4. 构建并启动容器

使用 docker-compose 启动应用：

```bash
docker-compose up -d
```

首次运行会自动构建镜像，可能需要 5-10 分钟（取决于网络速度）。

查看日志：

```bash
docker-compose logs -f xiaohongshu-app
```

### 5. 验证服务

访问以下地址验证服务是否正常运行：

- **API 首页**: http://localhost:12398/
- **健康检查**: http://localhost:12398/api/health
- **前端应用**: http://localhost:12398（如果已构建）

## 📝 配置详解

### .env 环境变量

| 变量名 | 默认值 | 说明 | 必需 |
|-------|-------|------|------|
| `GOOGLE_CLOUD_API_KEY` | 无 | Google Gemini API Key | ✅ |
| `IMAGE_API_KEY` | 无 | 图片生成服务 API Key | ✅ |
| `TEXT_API_BASE_URL` | https://api.bltcy.ai | 文字生成服务 Base URL | ❌ |
| `FLASK_DEBUG` | False | 调试模式（生产环保议 False） | ❌ |
| `FLASK_HOST` | 0.0.0.0 | 服务监听地址 | ❌ |
| `FLASK_PORT` | 12398 | 服务端口 | ❌ |
| `CORS_ORIGINS` | http://localhost:12398 | 允许的跨域源（逗号分隔） | ❌ |
| `OUTPUT_DIR` | /app/output | 输出目录 | ❌ |
| `DOCKER_PORT` | 12398 | 映射到主机的端口 | ❌ |

### config/image_providers.yaml 配置

这个文件定义了所有可用的图片生成服务商。选择一个作为 `active_provider`。

#### 使用 Google GenAI

```yaml
active_provider: google_genai
```

确保在 `.env` 中正确设置 `GOOGLE_CLOUD_API_KEY`。

#### 使用 OpenAI DALL-E

```yaml
active_provider: openai
```

在 `.env` 中添加：
```
OPENAI_API_KEY=your_openai_api_key_here
```

#### 使用自定义服务商

编辑 `config/image_providers.yaml` 中的 `custom` 配置：

```yaml
custom:
  type: openai_compatible
  api_key_env: CUSTOM_API_KEY
  base_url: https://your-api-endpoint.com
  model: your-model-name
  endpoint_type: images
  default_size: "1024x1024"
  supported_sizes:
    - "1024x1024"
  max_retries: 3
```

在 `.env` 中添加：
```
CUSTOM_API_KEY=your_api_key_here
```

## 🛠️ 常用命令

### 启动服务

```bash
# 后台启动
docker-compose up -d

# 前台启动（可看到实时日志）
docker-compose up

# 使用指定环境文件启动
docker-compose --env-file .env.docker up -d
```

### 查看日志

```bash
# 查看所有服务日志
docker-compose logs

# 查看特定服务的日志
docker-compose logs xiaohongshu-app

# 实时查看日志
docker-compose logs -f xiaohongshu-app

# 查看最后 100 行日志
docker-compose logs --tail=100
```

### 停止服务

```bash
# 停止但不删除容器
docker-compose stop

# 停止并删除容器
docker-compose down

# 删除所有数据（包括挂载卷）
docker-compose down -v
```

### 重启服务

```bash
# 重启所有服务
docker-compose restart

# 重启特定服务
docker-compose restart xiaohongshu-app

# 重新构建镜像并重启
docker-compose up -d --build
```

### 进入容器

```bash
# 进入运行中的容器的 shell
docker-compose exec xiaohongshu-app sh

# 执行单条命令
docker-compose exec xiaohongshu-app ls -la /app
```

### 查看容器状态

```bash
# 查看所有容器状态
docker-compose ps

# 查看容器详细信息
docker-compose ps --format "table {{.Service}}\t{{.State}}\t{{.Status}}"
```

### 清理资源

```bash
# 删除停止的容器
docker-compose rm

# 删除未使用的镜像
docker image prune

# 完整清理（删除所有停止的容器、网络、镜像）
docker system prune -a
```

## 📂 数据持久化

应用使用以下挂载点来保存数据：

### /app/output - 生成的图片

这个目录包含所有生成的图片文件。映射到主机的 `./output` 目录。

```bash
# 查看生成的图片
ls -la ./output/
```

### /app/history - 历史记录

这个目录包含所有历史记录数据（JSON 文件）。映射到主机的 `./history` 目录。

```bash
# 查看历史数据
ls -la ./history/
```

## 🌐 网络和 CORS 配置

### 本机访问

如果只在本机访问，保持默认配置：

```env
CORS_ORIGINS=http://localhost:12398
DOCKER_PORT=12398
```

### 远程服务器访问

如果需要从其他机器访问（例如使用域名 `example.com`）：

```env
CORS_ORIGINS=http://example.com,https://example.com
DOCKER_PORT=12398
```

然后通过反向代理（如 Nginx）配置：

```nginx
server {
    listen 80;
    server_name example.com;

    location / {
        proxy_pass http://localhost:12398;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

### Docker 内部通信

如果前端也在 Docker 中运行，可以使用容器名：

```env
CORS_ORIGINS=http://frontend:3000
```

## 🐛 故障排除

### 1. 容器启动失败

查看日志找出错误原因：

```bash
docker-compose logs
```

常见原因：
- 端口被占用：修改 `DOCKER_PORT`
- API Key 未设置：检查 `.env` 文件
- 内存不足：确保至少有 2GB 可用内存

### 2. 无法访问应用

```bash
# 检查容器是否运行
docker-compose ps

# 检查端口映射
docker-compose port xiaohongshu-app 12398

# 检查防火墙（Linux）
sudo ufw status
sudo ufw allow 12398

# 测试连接
curl http://localhost:12398/api/health
```

### 3. API Key 错误

检查 `.env` 文件中的 API Key 是否正确设置：

```bash
# 查看当前配置
grep -E "API_KEY|GOOGLE" .env

# 检查容器中的环境变量
docker-compose exec xiaohongshu-app env | grep API_KEY
```

### 4. 图片生成失败

检查 `config/image_providers.yaml` 中的 `active_provider` 设置：

```bash
# 查看当前使用的服务商
grep "active_provider:" config/image_providers.yaml

# 检查服务商配置
docker-compose exec xiaohongshu-app cat /app/image_providers.yaml | head -20
```

### 5. 内存或磁盘不足

```bash
# 查看 Docker 磁盘使用情况
docker system df

# 查看容器资源使用
docker stats

# 清理未使用资源
docker system prune -a
```

## 📊 性能优化

### 增加内存限制

编辑 `docker-compose.yml`，在 `xiaohongshu-app` 服务下添加：

```yaml
services:
  xiaohongshu-app:
    # ... 其他配置
    deploy:
      resources:
        limits:
          memory: 2G
        reservations:
          memory: 1G
```

### 增加 CPU 限制

```yaml
services:
  xiaohongshu-app:
    deploy:
      resources:
        limits:
          cpus: '2'
        reservations:
          cpus: '1'
```

### 优化构建时间

```bash
# 使用 BuildKit 加速构建
DOCKER_BUILDKIT=1 docker-compose up -d --build

# 或在 docker-compose.yml 中配置
# services:
#   xiaohongshu-app:
#     build:
#       context: .
#       cache_from:
#         - node:22-alpine
#         - python:3.11-slim
```

## 🔐 安全建议

### 1. 生产环境配置

```env
# 关闭调试模式
FLASK_DEBUG=False

# 使用强密钥（如果添加认证）
SECRET_KEY=your-strong-secret-key

# 限制 CORS 源
CORS_ORIGINS=https://your-domain.com

# 使用 HTTPS
# 需要配置 SSL 证书
```

### 2. API Key 管理

- **不要**在代码中硬编码 API Key
- **不要**提交 `.env` 文件到版本控制
- 使用环境变量或 Docker Secrets（Docker Swarm）
- 定期轮换 API Key

### 3. 网络隔离

只在需要时暴露端口：

```yaml
services:
  xiaohongshu-app:
    ports:
      - "127.0.0.1:12398:12398"  # 仅本机访问
```

### 4. 日志安全

避免在日志中记录敏感信息（API Key、密码等）。

## 📦 更新和维护

### 更新应用

```bash
# 拉取最新代码
git pull origin main

# 重新构建镜像
docker-compose down
docker-compose up -d --build
```

### 备份数据

```bash
# 备份生成的图片
cp -r ./output ./output.backup

# 备份历史记录
cp -r ./history ./history.backup

# 或使用 docker volume 备份
docker run --rm -v xiaohongshu-generator_output:/data -v $(pwd):/backup \
  busybox tar czf /backup/output.tar.gz -C /data .
```

### 恢复数据

```bash
# 恢复图片
cp -r ./output.backup/* ./output/

# 恢复历史记录
cp -r ./history.backup/* ./history/
```

## 📞 支持和反馈

如果遇到问题，请：

1. 检查 [故障排除](#-故障排除) 部分
2. 查看应用日志：`docker-compose logs`
3. 检查 API Key 和配置是否正确
4. 提交 Issue 到项目仓库

## 📄 License

MIT License - 详见项目根目录的 LICENSE 文件。
