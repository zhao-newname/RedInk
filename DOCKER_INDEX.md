# 🐳 Docker 部署 - 快速导航

> 为小红书图文生成器创建的完整 Docker 部署方案

---

## 🎯 我想要...

### 🚀 快速开始（5 分钟）
```bash
bash docker-check-config.sh     # 检查配置
bash docker-start.sh start -d   # 启动应用
# 访问 http://localhost:12398
```
→ 详见 [DOCKER_QUICKSTART.md](./DOCKER_QUICKSTART.md)

### 📚 学习完整部署方案
→ 详见 [DOCKER_DEPLOYMENT.md](./DOCKER_DEPLOYMENT.md)

### 🔍 了解所有文件用途
→ 详见 [DOCKER_FILES_README.md](./DOCKER_FILES_README.md)

### 🖥️ 在生产服务器部署
1. 使用 `.env.prod` 配置
2. 使用 `docker-compose.prod.yml` 启动
3. 配置 Nginx 反向代理（参考 `nginx.conf.example`）
4. 配置 Systemd 服务（参考 `xiaohongshu-docker.service.example`）

### 🆘 遇到问题
1. 运行配置检查：`bash docker-check-config.sh`
2. 查看日志：`docker-compose logs -f`
3. 查看完整故障排除指南：[DOCKER_DEPLOYMENT.md#-故障排除](./DOCKER_DEPLOYMENT.md#-故障排除)

---

## 📂 核心文件一览

### 🔧 配置文件

| 文件 | 用途 | 何时使用 |
|------|------|--------|
| `.env.docker` | 环境变量模板 | 开发环境（首选） |
| `.env.prod` | 生产环境变量模板 | 生产部署 |
| `config/image_providers.yaml` | 图片服务商配置 | 所有环境 |
| `.dockerignore` | Docker 构建忽略列表 | 自动使用 |

### 🐳 Docker 文件

| 文件 | 用途 | 说明 |
|------|------|------|
| `Dockerfile` | 镜像构建文件 | 三阶段构建，优化大小 |
| `docker-compose.yml` | 开发环境编排 | 标准开发配置 |
| `docker-compose.prod.yml` | 生产环境编排 | 生产级优化 |

### 🛠️ 脚本工具

| 脚本 | 功能 | 推荐度 |
|------|------|--------|
| `docker-start.sh` | 交互式启动脚本 | ⭐⭐⭐⭐⭐ 推荐 |
| `docker-check-config.sh` | 配置检查脚本 | ⭐⭐⭐⭐⭐ 推荐 |
| `Makefile` | Make 快捷命令 | ⭐⭐⭐⭐ 便捷 |

### 📖 文档

| 文档 | 适合人群 | 长度 |
|------|--------|------|
| `DOCKER_INDEX.md` | 所有人（本文件） | 2 分钟 |
| `DOCKER_QUICKSTART.md` | 想快速开始 | 5 分钟 |
| `DOCKER_DEPLOYMENT.md` | 想了解细节 | 30 分钟 |
| `DOCKER_FILES_README.md` | 想了解每个文件 | 20 分钟 |

### 🖥️ 服务器部署示例

| 文件 | 用途 |
|------|------|
| `nginx.conf.example` | Nginx 反向代理配置 |
| `xiaohongshu-docker.service.example` | Systemd 服务配置 |

---

## 📋 部署清单

### 开发环境部署（本机）

- [ ] 安装 Docker 和 Docker Compose
- [ ] 运行 `bash docker-check-config.sh`
- [ ] 复制 `.env.docker` 为 `.env`
- [ ] 编辑 `.env`，填入 API Key
- [ ] 运行 `bash docker-start.sh start -d`
- [ ] 访问 `http://localhost:12398` 验证

### 生产环境部署（服务器）

- [ ] 安装 Docker、Docker Compose、Nginx
- [ ] 申请 SSL 证书
- [ ] 复制 `.env.prod` 为 `.env`
- [ ] 编辑 `.env`，填入生产 API Key
- [ ] 编辑 `docker-compose.prod.yml`
- [ ] 配置 Nginx（参考 `nginx.conf.example`）
- [ ] 启动服务：`docker-compose -f docker-compose.prod.yml --env-file .env.prod up -d`
- [ ] 配置 Systemd（参考 `xiaohongshu-docker.service.example`）
- [ ] 验证：访问域名，检查 `/api/health`

---

## ⚡ 常用命令速查

### 使用脚本启动（推荐）

```bash
bash docker-start.sh help                # 显示帮助
bash docker-start.sh start -d            # 启动应用
bash docker-start.sh logs -f             # 查看日志
bash docker-start.sh shell               # 进入容器
bash docker-start.sh health              # 检查健康
bash docker-start.sh stop                # 停止应用
bash docker-start.sh rebuild -d          # 重新构建
```

### 使用 Docker Compose

```bash
docker-compose up -d                     # 启动
docker-compose down                      # 停止
docker-compose ps                        # 查看状态
docker-compose logs -f                   # 查看日志
docker-compose exec xiaohongshu-app sh   # 进入容器
```

### 使用 Makefile

```bash
make docker-up                           # 启动
make docker-down                         # 停止
make docker-logs                         # 日志
make docker-shell                        # 进入容器
make help                                # 帮助
```

---

## 🔐 重要安全提示

⚠️ **必读！**

1. **API Key 管理**
   - 不要提交 `.env` 到 Git
   - 使用 `.gitignore` 排除敏感文件
   - 定期轮换 API Key

2. **生产环境**
   - 使用 `.env.prod` 配置
   - 关闭调试模式
   - 使用 SSL/TLS
   - 配置反向代理

3. **数据备份**
   ```bash
   cp -r ./output ./output.backup
   cp -r ./history ./history.backup
   ```

---

## 🚀 现在开始吧！

### 第一步：检查系统

```bash
bash docker-check-config.sh
```

### 第二步：启动应用

```bash
bash docker-start.sh start -d
```

### 第三步：访问应用

打开浏览器访问：[http://localhost:12398](http://localhost:12398)

---

## 📞 需要帮助？

| 问题 | 查看文档 |
|------|--------|
| 快速开始 | [DOCKER_QUICKSTART.md](./DOCKER_QUICKSTART.md) |
| 详细配置 | [DOCKER_DEPLOYMENT.md](./DOCKER_DEPLOYMENT.md) |
| 文件说明 | [DOCKER_FILES_README.md](./DOCKER_FILES_README.md) |
| 故障排除 | [DOCKER_DEPLOYMENT.md#-故障排除](./DOCKER_DEPLOYMENT.md#-故障排除) |
| 所有命令 | 运行 `bash docker-start.sh help` 或 `make help` |

---

## 📊 系统架构

```
┌─────────────────────────────────────────┐
│          Docker Container               │
├─────────────────────────────────────────┤
│  Frontend (Vue 3 + Vite)                │
│  - 编译后的应用                         │
├─────────────────────────────────────────┤
│  Backend (Flask + Python 3.11)          │
│  - 文案生成 API                         │
│  - 图片生成 API                         │
│  - 历史记录管理                         │
├─────────────────────────────────────────┤
│  数据持久化                             │
│  - /app/output (生成的图片)             │
│  - /app/history (历史记录)              │
└─────────────────────────────────────────┘
         ↓ Port 12398 ↓
┌─────────────────────────────────────────┐
│        可选：Nginx 反向代理              │
│        (生产环境推荐)                    │
└─────────────────────────────────────────┘
         ↓ Domain HTTPS ↓
         互联网用户访问
```

---

## 📈 性能指标

| 指标 | 值 | 说明 |
|------|-----|------|
| 构建时间 | 5-10 分钟 | 首次构建（取决于网络）|
| 启动时间 | 10-30 秒 | 首次启动（预热）|
| 内存使用 | ~500MB | 基础运行 |
| 磁盘空间 | 2GB+ | 推荐 |
| 最大并发 | 15 | 图片生成任务 |

---

## 🎓 学习路径

### 初级用户
1. 阅读本文件（DOCKER_INDEX.md）
2. 阅读 DOCKER_QUICKSTART.md
3. 运行 `bash docker-start.sh start -d`

### 中级用户
1. 阅读 DOCKER_DEPLOYMENT.md
2. 理解配置文件
3. 尝试不同的服务商配置

### 高级用户
1. 阅读 DOCKER_FILES_README.md
2. 自定义 Dockerfile
3. 部署生产环境

---

## ✅ 部署检查

现在就运行检查：

```bash
bash docker-check-config.sh
```

应该看到：
```
✓ Docker 已安装
✓ Docker Compose 已安装
✓ 所有必需的项目文件存在
✓ 磁盘空间充足
✓ 系统内存充足
✓ 端口可用
```

---

## 📝 版本信息

- **项目**: 小红书图文生成器
- **Docker 支持**: ✅ 完整支持
- **Python 版本**: 3.11
- **Node.js 版本**: 22-alpine
- **更新时间**: 2024

---

**让我们开始部署吧！** 🚀

```bash
bash docker-start.sh start -d
```

祝你使用愉快！ 🎉
