# 🔄 技能更新方法

## 最简单的方法

```bash
# 进入技能目录
cd .trae/skills/trae-context-gist

# 一键更新
./update.sh        # macOS/Linux
# 或
.\update.ps1       # Windows
```

## 三种更新方式

### 1. 自动更新脚本（推荐）✨

**macOS/Linux:**
```bash
./update.sh
```

**Windows:**
```powershell
.\update.ps1
```

**功能:**
- ✅ 自动备份 `.env` 配置
- ✅ 拉取最新代码
- ✅ 恢复配置
- ✅ 自动安装依赖
- ✅ 安全暂存本地更改

### 2. Git 命令（快速）

```bash
git pull origin main
```

适用于没有本地修改的情况。

### 3. 手动更新（完整控制）

详细步骤请查看 [UPDATE_GUIDE.md](UPDATE_GUIDE.md)

## 更新后

1. **测试功能**：在 TRAE 中输入"整理上下文"
2. **查看更新**：https://github.com/ethanhuangcst/trae-context-gist/commits/main

## 常见问题

**Q: 会丢失 GitHub Token 吗？**  
A: 不会，脚本会自动备份和恢复 `.env` 文件。

**Q: 需要重启 TRAE 吗？**  
A: 建议重启 TRAE 以加载最新代码。

**Q: 更新失败怎么办？**  
A: 查看 [UPDATE_GUIDE.md](UPDATE_GUIDE.md) 的故障排除部分。

---

📖 **完整指南**: [UPDATE_GUIDE.md](UPDATE_GUIDE.md)  
🔗 **GitHub**: https://github.com/ethanhuangcst/trae-context-gist
