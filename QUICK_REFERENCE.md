# ⚡ Docker 部署 - 快速参考卡片

> 打印或收藏这个页面！完整的命令速查表

---

## 🚀 3 秒启动

```bash
bash docker-start.sh start -d
# 然后访问 http://localhost:12398
```

---

## 📋 命令速查表

### 启动脚本命令

```bash
bash docker-start.sh help              # 显示帮助信息
bash docker-start.sh start -d          # 启动应用（后台）
bash docker-start.sh stop              # 停止应用
bash docker-start.sh restart           # 重启应用
bash docker-start.sh restart -d        # 后台重启
bash docker-start.sh logs              # 显示日志
bash docker-start.sh logs -f           # 实时日志
bash docker-start.sh shell             # 进入容器
bash docker-start.sh health            # 健康检查
bash docker-start.sh status            # 查看状态
bash docker-start.sh rebuild -d        # 重新构建
bash docker-start.sh clean             # 完全清理
bash docker-check-config.sh            # 检查配置
```

### Docker Compose 命令

```bash
docker-compose up -d                   # 启动
docker-compose down                    # 停止
docker-compose ps                      # 状态
docker-compose logs -f                 # 日志
docker-compose restart                 # 重启
docker-compose exec xiaohongshu-app sh # 进入容器
docker-compose pull                    # 拉取镜像
docker-compose build                   # 构建镜像
docker-compose config                  # 验证配置
```

### Make 命令

```bash
make help                  # 显示帮助
make docker-up             # 启动
make docker-down           # 停止
make docker-logs           # 日志
make docker-restart        # 重启
make docker-shell          # 进入容器
make docker-status         # 状态
make docker-clean          # 清理
make config-init           # 初始化配置
make config-edit           # 编辑 .env

# 快捷别名
make up                    # = make docker-up
make down                  # = make docker-down
make logs                  # = make docker-logs
```

---

## 🔧 配置速查

### 修改端口

```bash
# 编辑 .env 文件
DOCKER_PORT=8080          # 改为想要的端口

# 重启应用
docker-compose down && docker-compose up -d
```

### 修改图片服务商

```bash
# 编辑 config/image_providers.yaml
active_provider: google_genai  # 改为 openai, image_api 等

# 重启应用
docker-compose restart
```

### 修改 API Key

```bash
# 编辑 .env 文件
nano .env

# 修改后重启
docker-compose restart
```

### 查看环境变量

```bash
docker-compose exec xiaohongshu-app env | grep -E "API|FLASK"
```

---

## 🆘 快速救急

### 容器无法启动

```bash
# 查看错误日志
docker-compose logs

# 检查配置
bash docker-check-config.sh

# 清理重试
docker-compose down -v
docker-compose up -d
```

### 端口被占用

```bash
# 查看端口占用
lsof -i :12398

# 修改端口
nano .env                 # 改 DOCKER_PORT
docker-compose down && docker-compose up -d
```

### 需要进入容器调试

```bash
# 进入容器
docker-compose exec xiaohongshu-app sh

# 查看日志
docker-compose logs -f

# 重新启动某个服务
docker-compose restart xiaohongshu-app
```

### 清理磁盘

```bash
# 删除停止的容器
docker container prune

# 删除未使用的镜像
docker image prune

# 完全清理
docker system prune -a
```

---

## 📁 文件位置速查

| 文件 | 位置 | 用途 |
|------|------|------|
| 配置 | `.env` | API Key 配置 |
| 图片服务 | `config/image_providers.yaml` | 服务商选择 |
| 生成图片 | `./output/` | 生成的图片 |
| 历史记录 | `./history/` | 历史数据 |
| 前端文件 | `./frontend/` | Vue 前端代码 |
| 后端文件 | `./backend/` | Flask 后端代码 |

---

## 🌐 URL 速查

| 功能 | URL |
|------|-----|
| 应用首页 | http://localhost:12398 |
| API 根路径 | http://localhost:12398/api |
| 健康检查 | http://localhost:12398/api/health |
| 生成大纲 | http://localhost:12398/api/outline |
| 生成图片 | http://localhost:12398/api/generate |
| 获取图片 | http://localhost:12398/api/images/\<filename\> |

---

## 📊 诊断命令

```bash
# 检查 Docker
docker --version

# 检查 Docker Compose
docker-compose --version

# 检查容器状态
docker-compose ps

# 查看镜像
docker images | grep xiaohongshu

# 查看卷
docker volume ls | grep xiaohongshu

# 查看网络
docker network ls

# 查看资源使用
docker stats

# 查看详细日志
docker-compose logs --tail=100

# 验证 YAML 配置
docker-compose config
```

---

## 🔐 生产部署速查

```bash
# 使用生产配置
docker-compose -f docker-compose.prod.yml \
  --env-file .env.prod \
  up -d

# 停止生产环境
docker-compose -f docker-compose.prod.yml down

# 查看生产日志
docker-compose -f docker-compose.prod.yml logs -f

# 配置 Nginx
sudo cp nginx.conf.example /etc/nginx/sites-available/xiaohongshu
sudo ln -s /etc/nginx/sites-available/xiaohongshu \
  /etc/nginx/sites-enabled/xiaohongshu
sudo nginx -s reload

# 设置 Systemd 服务
sudo cp xiaohongshu-docker.service.example \
  /etc/systemd/system/xiaohongshu-docker.service
sudo systemctl daemon-reload
sudo systemctl enable xiaohongshu-docker
sudo systemctl start xiaohongshu-docker
```

---

## 💾 备份恢复速查

```bash
# 备份所有数据
cp -r ./output ./output.backup
cp -r ./history ./history.backup

# 备份 Docker 卷
docker run --rm -v xiaohongshu-generator_output:/data \
  -v $(pwd):/backup busybox \
  tar czf /backup/output.tar.gz -C /data .

# 恢复数据
cp -r ./output.backup/* ./output/
cp -r ./history.backup/* ./history/

# 恢复 Docker 卷
docker run --rm -v xiaohongshu-generator_output:/data \
  -v $(pwd):/backup busybox \
  tar xzf /backup/output.tar.gz -C /data
```

---

## 🎯 日常操作速查表

### 工作流开始

```bash
# 1. 进入项目目录
cd xiaohongshu-generator

# 2. 检查配置
bash docker-check-config.sh

# 3. 启动应用
bash docker-start.sh start -d

# 4. 访问应用
open http://localhost:12398
```

### 工作流中间

```bash
# 查看日志
make docker-logs

# 查看状态
make docker-status

# 进入容器调试
make docker-shell

# 重启应用
make docker-restart
```

### 工作流结束

```bash
# 查看最终日志
docker-compose logs

# 停止应用
make docker-down

# 清理资源（可选）
docker system prune
```

---

## 📚 文档导航

| 需要 | 查看 |
|------|------|
| 快速导航 | DOCKER_INDEX.md |
| 5 分钟快速开始 | DOCKER_QUICKSTART.md |
| 30 分钟完整指南 | DOCKER_DEPLOYMENT.md |
| 文件详细说明 | DOCKER_FILES_README.md |
| 部署完成总结 | DEPLOYMENT_SUMMARY.md |
| 技术实现细节 | IMPLEMENTATION_NOTES.md |

---

## 🆘 常见问题极速答案

**Q: 如何启动？**
```bash
bash docker-start.sh start -d
```

**Q: 如何停止？**
```bash
docker-compose down
```

**Q: 如何查看日志？**
```bash
docker-compose logs -f
```

**Q: 如何修改 API Key？**
```bash
nano .env  # 然后 docker-compose restart
```

**Q: 如何修改端口？**
```bash
nano .env  # 改 DOCKER_PORT，然后重启
```

**Q: 如何进入容器？**
```bash
docker-compose exec xiaohongshu-app sh
```

**Q: 如何重新构建？**
```bash
docker-compose down && docker-compose up -d --build
```

**Q: 如何完全清理？**
```bash
docker-compose down -v && docker system prune -a
```

**Q: 如何备份数据？**
```bash
cp -r ./output ./output.backup
cp -r ./history ./history.backup
```

**Q: 如何查看生成的图片？**
```bash
ls -la ./output/
open ./output/  # 在 Finder/Explorer 中打开
```

---

## ⌨️ 快捷键和别名

### 添加到 ~/.bashrc 或 ~/.zshrc

```bash
# 添加到 shell 配置文件
alias xhsup='cd ~/xiaohongshu-generator && make docker-up'
alias xhsdown='cd ~/xiaohongshu-generator && make docker-down'
alias xhslogs='cd ~/xiaohongshu-generator && make docker-logs'
alias xhsshell='cd ~/xiaohongshu-generator && make docker-shell'

# 然后运行
xhsup    # 启动应用
xhslogs  # 查看日志
```

---

## 📱 手机记忆法

**记住 3 个最重要的命令:**

1️⃣ **启动**
```bash
bash docker-start.sh start -d
```

2️⃣ **查看日志**
```bash
docker-compose logs -f
```

3️⃣ **停止**
```bash
docker-compose down
```

---

## ✨ 提示和技巧

### 提示 1: 一条命令启动和测试
```bash
make docker-up && sleep 2 && docker-compose exec xiaohongshu-app curl http://localhost:12398/api/health
```

### 提示 2: 监视容器状态
```bash
watch -n 2 docker-compose ps
```

### 提示 3: 查看所有卷大小
```bash
docker system df
```

### 提示 4: 跟踪实时资源使用
```bash
docker stats --no-stream
```

### 提示 5: 快速清理日志
```bash
docker-compose logs > /dev/null
```

---

## 🎓 快速学习路径

**5 分钟:**
1. 运行 `bash docker-check-config.sh`
2. 运行 `bash docker-start.sh start -d`
3. 访问 http://localhost:12398

**15 分钟:**
1. 阅读 DOCKER_INDEX.md
2. 阅读 DOCKER_QUICKSTART.md
3. 尝试修改 .env 文件

**1 小时:**
1. 阅读 DOCKER_DEPLOYMENT.md
2. 尝试不同的命令
3. 查看日志和状态

---

## 🎉 现在就开始

```bash
# 最快的方式
bash docker-start.sh start -d

# 然后打开浏览器
http://localhost:12398

# 享受吧！
```

---

**打印本页面以便快速查阅！** 🖨️

最后更新: 2024-11-25
