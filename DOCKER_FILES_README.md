# 🐳 Docker 部署文件说明

本项目包含完整的 Docker 部署配置。以下是所有相关文件的说明及使用指南。

---

## 📁 文件结构

```
.
├── 🐳 Docker 核心文件
│   ├── Dockerfile                      # Docker 镜像构建文件（多阶段构建）
│   ├── docker-compose.yml              # Docker Compose 配置（开发环境）
│   ├── docker-compose.prod.yml         # Docker Compose 配置（生产环境）
│   └── .dockerignore                   # Docker 构建忽略列表
│
├── ⚙️ 配置文件
│   ├── .env.docker                     # 环境变量模板
│   ├── .env.prod                       # 生产环境变量模板
│   └── config/
│       └── image_providers.yaml        # 图片生成服务商配置
│
├── 🛠️ 启动脚本
│   ├── docker-start.sh                 # 交互式启动脚本（推荐使用）
│   ├── docker-check-config.sh          # 配置检查脚本
│   └── Makefile                        # Make 命令快捷方式
│
├── 📚 文档
│   ├── DOCKER_QUICKSTART.md            # 快速开始指南
│   ├── DOCKER_DEPLOYMENT.md            # 完整部署文档
│   ├── DOCKER_FILES_README.md          # 本文件
│   │
│   └── 服务器部署示例
│       ├── nginx.conf.example          # Nginx 反向代理配置
│       └── xiaohongshu-docker.service.example  # Systemd 服务文件
│
├── 📦 应用源代码
│   ├── backend/                        # Flask 后端
│   ├── frontend/                       # Vue 3 前端
│   ├── pyproject.toml                  # Python 项目配置
│   └── uv.lock                         # Python 依赖锁定文件
│
└── 📂 运行时目录（自动创建）
    ├── output/                         # 生成的图片（Docker 挂载点）
    └── history/                        # 历史记录数据（Docker 挂载点）
```

---

## 🚀 快速使用指南

### 第一次部署？

1. **快速检查配置：**
   ```bash
   bash docker-check-config.sh
   ```

2. **开始部署（推荐使用脚本）：**
   ```bash
   bash docker-start.sh start -d
   ```
   或使用 Make：
   ```bash
   make docker-up
   ```

3. **访问应用：**
   打开浏览器访问 `http://localhost:12398`

---

## 📋 文件详细说明

### 🐳 Docker 核心文件

#### `Dockerfile`
**用途:** Docker 镜像构建文件

**特点:**
- ✅ 三阶段构建（Node.js 前端 → Python 后端 → 最终运行时）
- ✅ 优化的层缓存，加快构建速度
- ✅ 最小化最终镜像大小
- ✅ 包含健康检查配置
- ✅ 非 root 用户运行（安全性）

**不需要修改，除非：**
- 需要改变 Python/Node.js 版本
- 添加额外的系统依赖

#### `docker-compose.yml`
**用途:** 开发环境容器编排配置

**特点:**
- ✅ 配置所有环境变量
- ✅ 配置卷（volume）挂载
- ✅ 自动重启策略
- ✅ 内置健康检查

**何时修改:**
- 修改映射端口（默认 12398）
- 修改卷挂载路径
- 添加其他服务（如 Redis、Database）

#### `docker-compose.prod.yml`
**用途:** 生产环境优化配置

**特点:**
- ✅ 禁用调试模式
- ✅ 资源限制（CPU 2核，内存 2GB）
- ✅ 生产级日志配置
- ✅ 仅本机端口绑定（需反向代理）
- ✅ 自动镜像缓存

**使用方式:**
```bash
docker-compose -f docker-compose.prod.yml --env-file .env.prod up -d
```

#### `.dockerignore`
**用途:** 指定构建时忽略的文件

**包含的内容:**
- Git 相关文件
- Node/Python 缓存和虚拟环境
- IDE 配置文件
- 构建缓存
- 环境文件
- 运行时生成的目录

**编辑建议:** 一般无需修改

---

### ⚙️ 配置文件

#### `.env.docker`
**用途:** 开发环境环境变量模板

**必需配置:**
```env
GOOGLE_CLOUD_API_KEY=your_key_here    # Google Gemini API Key
IMAGE_API_KEY=your_key_here           # 图片生成 API Key
```

**可选配置:**
```env
FLASK_DEBUG=False                      # 调试模式
DOCKER_PORT=12398                      # 映射端口
CORS_ORIGINS=http://localhost:12398    # 跨域源
```

**使用方式:**
```bash
# 第一次使用
cp .env.docker .env
nano .env  # 编辑填入 API Key
```

#### `.env.prod`
**用途:** 生产环境变量模板

**特点:**
- ✅ 调试模式关闭
- ✅ CORS 限制为具体域名
- ✅ 日志级别为 WARNING
- ✅ 包含性能配置

**关键设置:**
```env
FLASK_DEBUG=False                      # 必须
CORS_ORIGINS=https://yourdomain.com    # 改为你的域名
```

#### `config/image_providers.yaml`
**用途:** 图片生成服务商配置

**默认服务商:**
```yaml
active_provider: image_api
```

**支持的服务商:**
- `image_api` - Image API（推荐）
- `google_genai` - Google GenAI
- `openai` - OpenAI DALL-E
- `duckcoding` - DuckCoding
- `custom` - 自定义服务

**如何切换:**
```yaml
# 改这一行
active_provider: google_genai  # 改为你想要的服务商

# 然后确保在 .env 中设置了对应的 API Key
# 例如 google_genai 需要 GOOGLE_CLOUD_API_KEY
```

---

### 🛠️ 启动脚本

#### `docker-start.sh`
**用途:** 交互式 Docker 启动脚本（推荐）

**主要命令:**
```bash
# 启动应用
bash docker-start.sh start -d

# 停止应用
bash docker-start.sh stop

# 重启应用
bash docker-start.sh restart -d

# 查看实时日志
bash docker-start.sh logs -f

# 进入容器 shell
bash docker-start.sh shell

# 检查应用健康状态
bash docker-start.sh health

# 重新构建和启动
bash docker-start.sh rebuild -d

# 完全清理（删除容器和数据）
bash docker-start.sh clean

# 查看状态
bash docker-start.sh status

# 显示帮助
bash docker-start.sh help
```

**特点:**
- ✅ 彩色输出，易于理解
- ✅ 自动检查前置条件（Docker、Docker Compose）
- ✅ 自动创建缺失的配置文件
- ✅ 健康检查（自动等待服务启动）
- ✅ 详细的错误提示

**选项:**
- `-d, --detach` - 后台运行
- `-f, --follow` - 跟随日志（logs 命令）
- `--port PORT` - 指定端口
- `--env-file FILE` - 指定环境文件

#### `docker-check-config.sh`
**用途:** 配置检查脚本

**检查项:**
- ✅ Docker 是否安装和运行
- ✅ Docker Compose 是否安装
- ✅ 项目文件是否完整
- ✅ 环境变量是否设置
- ✅ API Key 是否填入
- ✅ 图片服务商配置是否正确
- ✅ 磁盘空间是否充足
- ✅ 系统内存是否充足
- ✅ 端口是否可用
- ✅ Git 安全配置

**使用方式:**
```bash
bash docker-check-config.sh
```

**输出:**
```
✓ 通过
✗ 失败
⚠ 警告
```

#### `Makefile`
**用途:** Make 命令快捷方式

**常用命令:**
```bash
make help              # 显示帮助
make docker-up         # 启动应用
make docker-down       # 停止应用
make docker-logs       # 查看日志
make docker-shell      # 进入容器
make docker-clean      # 清理资源
make docker-status     # 查看状态

# 简短别名
make up                # 同上
make down
make logs
make status
```

**初始化命令:**
```bash
make config-init       # 初始化配置文件
make config-edit       # 编辑 .env
```

---

### 📚 文档文件

#### `DOCKER_QUICKSTART.md`
**用途:** 5 分钟快速开始指南

**适合:** 第一次使用 Docker 部署的用户

**内容:**
- 快速启动步骤
- 常用命令速查
- 常见问题解答
- 配置说明

#### `DOCKER_DEPLOYMENT.md`
**用途:** 完整的 Docker 部署文档

**适合:** 需要深入了解部署细节的用户

**内容:**
- 项目结构说明
- 详细的配置指南
- 所有 Docker Compose 命令
- 网络和 CORS 配置
- 数据持久化说明
- 故障排除指南
- 性能优化
- 安全建议

---

### 🖥️ 服务器部署示例

#### `nginx.conf.example`
**用途:** Nginx 反向代理配置示例

**使用场景:**
- 在生产服务器上使用域名访问
- 配置 HTTPS/SSL
- 负载均衡
- 限速和防护

**关键配置:**
```nginx
upstream xiaohongshu_backend {
    server 127.0.0.1:12398;
}

server {
    server_name yourdomain.com;
    ssl_certificate /etc/nginx/ssl/...;  # SSL 证书
    
    location / {
        proxy_pass http://xiaohongshu_backend;
    }
}
```

**安装步骤:**
1. 复制到 `/etc/nginx/sites-available/xiaohongshu`
2. 修改 `server_name` 和 SSL 证书路径
3. 创建软链接：`ln -s /etc/nginx/sites-available/xiaohongshu /etc/nginx/sites-enabled/`
4. 重载 Nginx：`sudo nginx -s reload`

#### `xiaohongshu-docker.service.example`
**用途:** Systemd 服务配置（Linux 系统）

**功能:**
- ✅ Docker 应用开机自启
- ✅ 自动重启失败的服务
- ✅ 集成系统日志

**安装步骤:**
```bash
# 1. 复制文件
sudo cp xiaohongshu-docker.service.example /etc/systemd/system/xiaohongshu-docker.service

# 2. 修改文件（改为实际用户和路径）
sudo nano /etc/systemd/system/xiaohongshu-docker.service

# 3. 重新加载
sudo systemctl daemon-reload

# 4. 启用和启动
sudo systemctl enable xiaohongshu-docker.service
sudo systemctl start xiaohongshu-docker.service
```

**常用命令:**
```bash
sudo systemctl status xiaohongshu-docker
sudo systemctl restart xiaohongshu-docker
sudo systemctl stop xiaohongshu-docker
journalctl -u xiaohongshu-docker -f  # 查看日志
```

---

## 🎯 使用流程图

### 首次部署

```
1. 检查配置
   └─> bash docker-check-config.sh

2. 初始化配置
   └─> bash docker-start.sh start -d
       或 make docker-up

3. 验证应用
   └─> http://localhost:12398
   └─> docker-compose logs -f

4. 享受应用
   └─> 开始使用！
```

### 日常维护

```
启动应用       └─> make docker-up 或 docker-compose up -d
查看日志       └─> make docker-logs 或 docker-compose logs -f
进入容器       └─> make docker-shell 或 docker-compose exec xiaohongshu-app sh
停止应用       └─> make docker-down 或 docker-compose down
重启应用       └─> make docker-restart 或 docker-compose restart
完全清理       └─> make docker-clean 或 docker-compose down -v
```

### 生产部署

```
准备环境       └─> 安装 Docker、Nginx、SSL 证书
配置文件       └─> .env.prod + image_providers.yaml
启动服务       └─> docker-compose -f docker-compose.prod.yml --env-file .env.prod up -d
配置 Nginx     └─> nginx.conf.example
启用 Systemd   └─> xiaohongshu-docker.service.example
监控日志       └─> journalctl -u xiaohongshu-docker -f
```

---

## 🔧 配置决策树

### 如何选择启动方式？

```
         需要启动应用吗？
              ↓
     是否第一次部署？
       ↙          ↖
      是           否
      ↓            ↓
   检查配置    直接启动
   ↓            ↓
bash docker-    docker-compose
check-config    up -d
   ↓            
创建 .env
   ↓
填入 API Key
   ↓
bash docker-
start.sh
```

### 如何选择环境变量文件？

```
        选择环境
        ↙      ↖
      开发      生产
      ↓        ↓
    .env    .env.prod
      ↓        ↓
  docker-  docker-compose
  compose  -f docker-
  up -d    compose.prod.yml
           --env-file
           .env.prod up -d
```

---

## ⚡ 性能优化建议

### 构建优化

```bash
# 启用 BuildKit 加速构建
DOCKER_BUILDKIT=1 docker-compose up -d --build
```

### 运行时优化

**增加内存限制（docker-compose.yml）:**
```yaml
deploy:
  resources:
    limits:
      memory: 4G
```

**增加 CPU 限制:**
```yaml
deploy:
  resources:
    limits:
      cpus: '4'
```

---

## 🔐 安全检查清单

- [ ] 关闭调试模式（生产环境）
- [ ] 使用 `.env.prod` 配置
- [ ] 限制 CORS 源为具体域名
- [ ] 设置 SSL/TLS 证书
- [ ] 使用 Nginx 反向代理
- [ ] 不提交 `.env` 到版本控制
- [ ] 定期轮换 API Key
- [ ] 启用日志审计
- [ ] 定期备份数据

---

## 📞 故障排除快速指南

| 问题 | 解决方案 |
|------|--------|
| 容器无法启动 | `docker-compose logs` 查看错误 |
| 端口被占用 | 修改 `.env` 中的 `DOCKER_PORT` |
| API Key 错误 | 检查 `.env` 和 `config/image_providers.yaml` |
| 前端无法访问 | 检查 CORS 配置和防火墙 |
| 磁盘满了 | `docker system prune -a` 清理未使用资源 |

---

## 📖 完整文档导航

- 📘 **快速开始** → [`DOCKER_QUICKSTART.md`](./DOCKER_QUICKSTART.md)
- 📗 **完整指南** → [`DOCKER_DEPLOYMENT.md`](./DOCKER_DEPLOYMENT.md)
- 📙 **本文件** → [`DOCKER_FILES_README.md`](./DOCKER_FILES_README.md)
- 📕 **项目主文档** → [`README.md`](./README.md)

---

## ✅ 总结

### 快速开始（3 步）

```bash
# 1. 检查配置
bash docker-check-config.sh

# 2. 启动应用
bash docker-start.sh start -d

# 3. 访问应用
# 打开浏览器访问 http://localhost:12398
```

### 日常使用

```bash
# 使用 Make 快捷命令
make docker-up          # 启动
make docker-logs        # 查看日志
make docker-down        # 停止
```

### 获取帮助

```bash
# 显示脚本帮助
bash docker-start.sh help

# 显示 Make 帮助
make help

# 查看完整文档
cat DOCKER_DEPLOYMENT.md
```

---

**祝你使用愉快！** 🚀
