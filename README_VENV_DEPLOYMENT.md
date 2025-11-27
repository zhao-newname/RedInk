# venv 部署方案 - README

> 红墨 AI 图文生成器完整的 Python venv 环境部署指南

---

## 📌 重要说明

本部署方案提供了**完整的 venv 虚拟环境部署解决方案**，包括：

- ✅ 详细的部署指南文档（5份）
- ✅ 自动化启动脚本（2份 - Linux/macOS + Windows）
- ✅ 快速上手指南
- ✅ 常见问题解答
- ✅ 生产环境部署说明
- ✅ 完整的故障排查指南

---

## 🚀 5秒快速开始

```bash
git clone https://github.com/HisMax/RedInk.git
cd RedInk
bash venv-start.sh setup    # 首次设置
bash venv-start.sh start    # 启动服务
# 打开 http://localhost:5173
```

---

## 📚 文档导航

### 🎯 按需求选择文档

#### 1. 我想立即开始（3分钟）
👉 **[VENV_QUICKSTART.md](./VENV_QUICKSTART.md)**
- 最快的部署方式
- 一句话快速部署
- 常用命令速查表

#### 2. 我想了解全过程（30分钟）
👉 **[VENV_DEPLOYMENT_GUIDE.md](./VENV_DEPLOYMENT_GUIDE.md)**
- 系统要求和检查
- 详细的部署步骤
- 生产环境部署
- 故障排查指南

#### 3. 我遇到了问题（按需查阅）
👉 **[VENV_FAQ.md](./VENV_FAQ.md)**
- 常见问题速查表
- 快速故障排查
- 分类问题解答

#### 4. 我需要导航帮助（5分钟）
👉 **[VENV_INDEX.md](./VENV_INDEX.md)**
- 文档总览和导航
- 场景选择指南
- 学习路径建议

#### 5. 我想了解方案概览（10分钟）
👉 **[VENV_DEPLOYMENT_SUMMARY.md](./VENV_DEPLOYMENT_SUMMARY.md)**
- 文档总结
- 快速查找表
- 部署检查清单

---

## 🛠️ 启动脚本使用

### Linux / macOS

```bash
# 赋予执行权限（首次需要）
chmod +x venv-start.sh

# 查看帮助
bash venv-start.sh help

# 首次设置
bash venv-start.sh setup

# 启动服务
bash venv-start.sh start

# 停止服务
bash venv-start.sh stop

# 查看状态
bash venv-start.sh status

# 查看实时日志
bash venv-start.sh logs

# 进入虚拟环境 shell
bash venv-start.sh shell
```

### Windows

```bash
# 首次设置
venv-start.bat setup

# 启动服务
venv-start.bat start

# 停止服务
venv-start.bat stop

# 查看状态
venv-start.bat status
```

---

## ✨ 核心特性

✅ **完全开源** - 基于 CC BY-NC-SA 4.0 协议  
✅ **零依赖** - 除了 Python、Node.js、pnpm、uv  
✅ **快速部署** - 3-5 分钟完成初始部署  
✅ **详细文档** - 从快速开始到生产部署  
✅ **自动化脚本** - 一键启动/停止/诊断  
✅ **故障排查** - 完整的问题解决方案  
✅ **生产就绪** - 包含 Nginx、SSL、systemd 配置  

---

## 📋 系统要求

| 项目 | 要求 | 验证命令 |
|------|------|---------|
| **Python** | 3.11+ | `python3 --version` |
| **Node.js** | 18+ | `node --version` |
| **pnpm** | 最新 | `pnpm --version` |
| **uv** | 最新 | `uv --version` |
| **操作系统** | Linux/macOS/Windows | - |

---

## 📖 文档目录结构

```
RedInk/
├── README.md                          # 项目主文档
├── README_VENV_DEPLOYMENT.md          # 本文档
├── VENV_INDEX.md                      # 📍 文档导航中心
├── VENV_QUICKSTART.md                 # 🚀 5分钟快速开始
├── VENV_DEPLOYMENT_GUIDE.md           # 📚 完整部署指南（30分钟）
├── VENV_FAQ.md                        # ❓ 常见问题解答
├── VENV_DEPLOYMENT_SUMMARY.md         # 📝 方案总结
├── venv-start.sh                      # 🛠️ 启动脚本（Linux/macOS）
├── venv-start.bat                     # 🛠️ 启动脚本（Windows）
│
├── backend/                           # 后端代码
├── frontend/                          # 前端代码
├── output/                            # 生成的图片输出
├── history/                           # 历史记录
├── pyproject.toml                     # Python 项目配置
├── text_providers.yaml.example        # 文本生成配置示例
└── image_providers.yaml.example       # 图片生成配置示例
```

---

## 🎯 应用场景

| 场景 | 推荐方案 | 文档 |
|------|---------|------|
| **本地开发** | venv | VENV_QUICKSTART.md |
| **快速体验** | venv + 启动脚本 | VENV_QUICKSTART.md |
| **学习 Python** | venv 手动部署 | VENV_DEPLOYMENT_GUIDE.md |
| **单机部署** | venv + systemd | VENV_DEPLOYMENT_GUIDE.md - 生产环境 |
| **多机部署** | Docker（推荐） | 查看项目内 DOCKER_INDEX.md |
| **团队开发** | venv + Git 共享 | VENV_INDEX.md |

---

## 📱 访问地址

部署完成后：

| 服务 | 地址 | 说明 |
|------|------|------|
| **前端应用** | http://localhost:5173 | 主界面 |
| **后端 API** | http://localhost:12398 | API 接口 |
| **API 文档** | http://localhost:12398/ | 接口说明 |

---

## 🔄 推荐部署流程

### 第一次部署

```
1. 阅读本文档 (5分钟)
   ↓
2. 查看 VENV_QUICKSTART.md (5分钟)
   ↓
3. 运行 bash venv-start.sh setup (2分钟)
   ↓
4. 配置 API Key (5分钟)
   ↓
5. 运行 bash venv-start.sh start (1分钟)
   ↓
6. 打开浏览器访问应用 ✓
```

### 再次启动（日常使用）

```bash
# 仅需一行命令
bash venv-start.sh start
```

### 生产环境部署

```
1. 阅读 VENV_DEPLOYMENT_GUIDE.md 生产部分
   ↓
2. 准备服务器环境
   ↓
3. 执行项目部署
   ↓
4. 配置 Nginx 反向代理
   ↓
5. 配置 SSL 证书
   ↓
6. 启用 systemd 服务
   ↓
7. 验证部署完成 ✓
```

---

## 🆘 快速故障排查

遇到问题？按以下步骤排查：

### 第一步：查看启动脚本状态
```bash
bash venv-start.sh status
```

### 第二步：查看实时日志
```bash
bash venv-start.sh logs
```

### 第三步：查看 FAQ
👉 如果日志中有关键词，在 [VENV_FAQ.md](./VENV_FAQ.md) 中搜索

### 第四步：查看详细指南
👉 在 [VENV_DEPLOYMENT_GUIDE.md](./VENV_DEPLOYMENT_GUIDE.md) 中查看故障排查部分

### 第五步：提交问题
👉 如果以上都没有帮助，提交 [GitHub Issue](https://github.com/HisMax/RedInk/issues)

---

## 📊 文档速查表

| 需求 | 查看文件 | 位置 |
|------|---------|------|
| 快速开始 | VENV_QUICKSTART.md | 开头 |
| Python 安装 | VENV_DEPLOYMENT_GUIDE.md | 第一步 |
| 虚拟环境 | VENV_DEPLOYMENT_GUIDE.md | 第三步 |
| API 配置 | VENV_DEPLOYMENT_GUIDE.md | 第四步 |
| 启动方式 | VENV_DEPLOYMENT_GUIDE.md | 启动服务章节 |
| 后台运行 | VENV_DEPLOYMENT_GUIDE.md | 方式二 |
| Systemd 服务 | VENV_DEPLOYMENT_GUIDE.md | 方式三 |
| Nginx 配置 | VENV_DEPLOYMENT_GUIDE.md | 生产环境部分 |
| SSL 证书 | VENV_DEPLOYMENT_GUIDE.md | 生产环境部分 |
| 常见问题 | VENV_FAQ.md | 相关章节 |
| 依赖问题 | VENV_FAQ.md | 依赖安装相关 |
| 端口占用 | VENV_FAQ.md | 启动和运行相关 |

---

## 💡 使用建议

### 对于初学者
```
1. 首先快速浏览本文档
2. 按照 VENV_QUICKSTART.md 操作
3. 使用 venv-start.sh 脚本启动
4. 有问题查看 VENV_FAQ.md
```

### 对于 Python 开发者
```
1. 直接查看 VENV_DEPLOYMENT_GUIDE.md
2. 手动按步骤部署（更有利于理解）
3. 根据需要参考其他文档
```

### 对于运维人员
```
1. 查看 VENV_DEPLOYMENT_GUIDE.md - 生产环境部分
2. 准备服务器环境
3. 按步骤部署和配置
4. 配置监控和备份
```

---

## 🎓 学习资源

### 官方文档
- [Python venv 官方文档](https://docs.python.org/3/library/venv.html)
- [Flask 官方文档](https://flask.palletsprojects.com/)
- [Vue 3 官方文档](https://vuejs.org/)

### 项目资源
- [项目仓库](https://github.com/HisMax/RedInk)
- [作者主页](https://github.com/HisMax)

### 社区资源
- [Linux.do 社区](https://linux.do/)
- [GitHub Issues](https://github.com/HisMax/RedInk/issues)

---

## 📞 获取支持

### 文档支持（推荐首选）
1. 查看 [VENV_FAQ.md](./VENV_FAQ.md) 的快速故障排查
2. 在相应文档中搜索关键词
3. 查看 [VENV_DEPLOYMENT_GUIDE.md](./VENV_DEPLOYMENT_GUIDE.md) 的故障排查部分

### 社区支持
- **GitHub Issues**: https://github.com/HisMax/RedInk/issues
- **Linux.do 原帖**: https://linux.do/（搜索相关讨论）

### 联系作者
- **Email**: histonemax@gmail.com
- **微信**: Histone2024（请注明"venv 部署问题"）
- **GitHub**: @HisMax

---

## 🎉 现在开始吧！

### 最快的方式

```bash
# 一键快速部署（推荐）
cd /path/to/RedInk
bash venv-start.sh setup
bash venv-start.sh start
```

### 或按照步骤来

查看 → [VENV_QUICKSTART.md](./VENV_QUICKSTART.md)

### 或想了解全部细节

查看 → [VENV_DEPLOYMENT_GUIDE.md](./VENV_DEPLOYMENT_GUIDE.md)

---

## 📋 部署检查清单

在开始之前，确保您已：

- [ ] 阅读了本文档
- [ ] Python 3.11+ 已安装
- [ ] Node.js 18+ 已安装
- [ ] pnpm 已安装
- [ ] uv 已安装
- [ ] 项目代码已克隆
- [ ] 网络连接正常

部署中需要：

- [ ] 虚拟环境已创建
- [ ] 依赖已安装
- [ ] 配置文件已创建
- [ ] API Key 已填写

部署后验证：

- [ ] 后端正在运行（http://localhost:12398）
- [ ] 前端正在运行（http://localhost:5173）
- [ ] 可以访问应用
- [ ] API 调用正常

---

## 📝 文档版本

| 项目 | 信息 |
|------|------|
| 文档版本 | 1.0.0 |
| 更新时间 | 2024年11月 |
| 维护者 | HisMax（默子） |
| 项目协议 | CC BY-NC-SA 4.0 |

---

## 🙏 致谢

感谢您选择红墨！如果这个项目对您有帮助，欢迎：

- ⭐ Star 本项目
- 📢 分享给朋友
- 💬 提供反馈和建议
- 🤝 参与贡献

---

**祝您使用愉快！** ✨

有任何问题，欢迎：
- 查看文档
- 提交 Issue
- 联系作者

**开始部署**: [VENV_QUICKSTART.md](./VENV_QUICKSTART.md) →
