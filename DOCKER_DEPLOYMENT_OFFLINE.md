# Docker 离线部署指南

由于当前环境的网络限制，本文档说明如何在有网络连接的系统上部署 Docker。

## 快速开始

### 前置条件
- Docker 版本 29.0+
- Docker Compose 版本 2.0+
- 主机网络连接正常

### 部署步骤

#### 1. 准备环境配置

```bash
# 进入项目目录
cd /path/to/xiaohongshu-generator

# 复制并编辑配置文件
cp .env.docker .env

# 编辑 .env 文件，填入 API 密钥
nano .env
```

配置文件中必须填入的项：
- `GOOGLE_CLOUD_API_KEY` - Google Gemini API 密钥
- `IMAGE_API_KEY` - 图片生成 API 密钥
- `CORS_ORIGINS` - 前端 CORS 源地址

#### 2. 构建 Docker 镜像

使用完整的多阶段 Dockerfile（推荐，自动构建前端）：

```bash
# 构建镜像
docker build -t xiaohongshu-generator:latest .

# 或使用 docker-compose 自动构建
docker compose build
```

#### 3. 启动容器

```bash
# 启动服务（完整方式）
docker compose up -d

# 或使用简化版本（仅后端）
docker compose -f docker-compose.prod-simple.yml up -d
```

#### 4. 检查服务状态

```bash
# 查看运行的容器
docker ps

# 查看日志
docker logs xiaohongshu-generator

# 实时查看日志
docker logs -f xiaohongshu-generator

# 进入容器 shell
docker exec -it xiaohongshu-generator bash
```

#### 5. 访问应用

打开浏览器访问：`http://localhost:12398`

或通过 curl 测试 API：

```bash
# 测试健康检查
curl http://localhost:12398/api/health

# 测试 API 首页
curl http://localhost:12398/
```

## Docker 文件说明

### Dockerfile（完整版，推荐用于生产环境）
- **优点**：自动构建前端，包含所有优化
- **缺点**：需要网络下载依赖，构建时间较长
- **使用场景**：首次部署、生产环境

```bash
docker build -t xiaohongshu-generator:latest .
```

### Dockerfile.prod（简化版，用于前端已构建的情况）
- **优点**：仅构建后端，构建时间短
- **缺点**：需要前端已在 `frontend/dist` 构建完毕
- **使用场景**：快速开发、前端静态构建

```bash
docker build -f Dockerfile.prod -t xiaohongshu-generator:latest .
```

## 配置说明

### 环境变量（.env 文件）

```env
# API 配置
GOOGLE_CLOUD_API_KEY=your_key_here       # Google Gemini API 密钥
IMAGE_API_KEY=your_key_here              # 图片生成 API 密钥
TEXT_API_BASE_URL=https://api.bltcy.ai   # 文字生成服务地址

# Flask 配置
FLASK_DEBUG=False                         # 生产环境设为 False
FLASK_HOST=0.0.0.0                      # Docker 内必须为 0.0.0.0
FLASK_PORT=12398                         # 内部端口

# CORS 配置
CORS_ORIGINS=http://localhost:12398      # 前端地址

# 文件配置
OUTPUT_DIR=/app/output                   # 输出目录（Docker 内路径）

# Docker 配置
DOCKER_PORT=12398                        # 主机暴露端口
LOG_LEVEL=INFO                          # 日志级别
```

### 图片生成服务配置（config/image_providers.yaml）

此文件定义使用哪个图片生成服务：

```yaml
active_provider: image_api    # 当前启用的服务商

providers:
  image_api:
    api_key_env: IMAGE_API_KEY
    base_url: https://your-api-endpoint.com
    # ... 其他配置
```

支持的服务商：
- `image_api` - 自定义图片 API 服务
- `google_genai` - Google Gemini
- `openai` - OpenAI DALL-E
- `duckcoding` - DuckCoding
- `custom` - 自定义服务

## 常见问题

### Q1: 容器启动但无法访问？
- 检查防火墙设置
- 确认端口映射：`docker ps`
- 检查容器日志：`docker logs xiaohongshu-generator`

### Q2: API 密钥错误？
- 检查 `.env` 文件中的密钥
- 重启容器：`docker restart xiaohongshu-generator`

### Q3: 如何更新代码？
```bash
# 停止容器
docker compose down

# 更新代码
git pull

# 重新构建
docker compose build

# 重新启动
docker compose up -d
```

### Q4: 如何查看输出文件？
- 主机上的 `./output` 目录对应容器 `/app/output`
- 生成的图片保存在主机的 `output` 文件夹中

### Q5: 如何备份数据？
```bash
# 备份输出文件
cp -r output output.backup

# 备份历史数据
cp -r history history.backup
```

## 网络配置（适用于代理或防火墙环境）

如需使用代理，在 `.env` 中添加：

```env
HTTP_PROXY=http://proxy.example.com:8080
HTTPS_PROXY=https://proxy.example.com:8080
NO_PROXY=localhost,127.0.0.1
```

## 生产部署建议

### 使用 Docker Compose 生产配置

```bash
docker compose -f docker-compose.prod.yml up -d
```

### 配置 Nginx 反向代理

参考 `nginx.conf.example` 文件配置 Nginx：

```bash
sudo cp nginx.conf.example /etc/nginx/sites-available/xiaohongshu
sudo ln -s /etc/nginx/sites-available/xiaohongshu /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

### 配置 Systemd 服务自启动

参考 `xiaohongshu-docker.service.example` 文件：

```bash
sudo cp xiaohongshu-docker.service.example /etc/systemd/system/xiaohongshu.service
sudo systemctl daemon-reload
sudo systemctl enable xiaohongshu.service
sudo systemctl start xiaohongshu.service
```

### 监控和日志

```bash
# 查看容器资源使用情况
docker stats xiaohongshu-generator

# 导出日志
docker logs xiaohongshu-generator > app.log

# 查看 systemd 日志（如果使用 systemd）
journalctl -u xiaohongshu.service -f
```

## 故障排查

### 构建失败：网络错误
- 检查网络连接：`ping registry.npmjs.org`
- 尝试使用 VPN 或代理
- 或使用预构建的前端：`docker build -f Dockerfile.prod`

### 容器启动后立即退出
- 查看日志：`docker logs xiaohongshu-generator`
- 检查 Flask 配置
- 检查 Python 依赖安装

### 健康检查失败
- 检查 API 端点是否响应
- 查看容器内网络：`docker exec xiaohongshu-generator curl http://localhost:12398/api/health`

## 进阶配置

### 自定义模型和参数

编辑 `backend/config.py` 修改默认配置。

### 添加自定义图片生成服务

在 `config/image_providers.yaml` 中添加新的提供商配置。

### 挂载自定义配置文件

在 `docker-compose.yml` 中修改 volumes 部分。

## 备份和恢复

### 创建备份

```bash
# 备份容器和数据
docker exec xiaohongshu-generator tar -czf /tmp/backup.tar.gz /app/output /app/history
docker cp xiaohongshu-generator:/tmp/backup.tar.gz ./backup.tar.gz
```

### 恢复备份

```bash
docker cp ./backup.tar.gz xiaohongshu-generator:/tmp/
docker exec xiaohongshu-generator tar -xzf /tmp/backup.tar.gz -C /
```

## 参考资源

- Docker 官方文档：https://docs.docker.com/
- Docker Compose 文档：https://docs.docker.com/compose/
- 项目 README：见 README.md
- 部署文档索引：见 DOCKER_INDEX.md

