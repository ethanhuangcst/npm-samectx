# trae-context-gist 技能

## 概述
自动整理 TRAE CN 对话上下文，生成结构化笔记并存储到 GitHub Gist 的技能。
**支持本地同步，即使网络不可用也能正常工作！**
**支持按项目组织笔记，方便管理和检索！**

## 安装状态
✅ 已完成安装和测试

## 功能特性

### 1. 上下文分析
- 自动提取对话中的任务
- 识别关键信息点
- 记录重要决策

### 2. 云存储 + 本地同步
- 自动上传到 GitHub Gist
- **优先保存到本地，确保数据不丢失**
- 私有存储，确保数据安全
- 自动版本控制
- **Gist 失败时自动降级为本地存储**

### 3. 按项目组织
- 自动从对话中识别项目名称
- 按项目创建子目录存储笔记
- Gist 描述包含项目信息
- 支持按项目筛选和搜索

### 4. 本地索引
- 维护笔记索引文件
- 支持关键词搜索
- 支持按项目搜索
- 快速访问历史笔记
- **记录同步状态（synced/local-only）**

### 5. 本地笔记存储
- 所有笔记自动保存到 `notes/` 目录
- 离线环境也能正常使用
- 双重保障，数据更安全

## 快速部署（3 步）

### 步骤 1：安装依赖
```bash
cd .trae/skills/trae-context-gist
npm install
```

### 步骤 2：配置 GitHub Token
```bash
# 复制示例文件
cp .env.example .env

# 编辑 .env 文件，添加您的 GitHub Token
# 获取地址：https://github.com/settings/tokens
# 需要选择 "gist" 权限
GITHUB_TOKEN=your_github_token_here
```

### 步骤 3：测试技能
```bash
node test.js
```

如果看到 "✓ 上下文处理功能测试通过"，说明部署成功！

## 使用方法

### 手动触发
在 TRAE CN 中输入：
```
整理上下文
```

### 自动触发
- 每小时自动执行一次
- 对话结束时自动执行

### 项目命名
对话中包含以下格式会自动识别项目名称：
```
项目：my-project
项目名称：我的项目
任务：项目名称
```

如果不指定项目名称，默认使用 `default`。

## 文件结构

```
trae-context-gist/
├── .env              # 环境配置（包含 GitHub Token）
├── .env.example      # 环境配置示例
├── SKILL.md          # 技能定义文件
├── index.js          # 技能主程序
├── package.json      # 依赖配置
├── test.js           # 测试脚本
├── notes/            # 本地笔记目录（自动生成）
│   ├── project1/     # 按项目分类
│   │   └── context_xxx.json
│   ├── project2/
│   └── default/     # 默认项目
├── index.json        # 本地笔记索引（自动生成）
└── README.md         # 本文件
```

## 配置说明

### GitHub Token
在 `.env` 文件中配置，需要 `gist` 权限。

### 本地笔记目录（可选）
可以自定义本地笔记存储位置：

```bash
# 使用绝对路径
LOCAL_NOTES_DIR=/Users/ethanhuang/Documents/Notes/trae-context

# 使用相对路径
LOCAL_NOTES_DIR=./data/notes

# 不配置则使用默认目录：notes/
```

### 常用配置示例
| 配置 | 路径类型 | 位置 |
|------|---------|------|
| 默认 | 相对 | `.trae/skills/trae-context-gist/notes/` |
| 项目目录 | 相对 | `.trae/skills/trae-context-gist/data/notes/` |
| 个人目录 | 绝对 | `~/Documents/Notes/trae-context` |
| Dropbox | 绝对 | `~/Dropbox/Notes/trae-context` |
| 外置硬盘 | 绝对 | `/Volumes/ExternalDrive/Notes` |

## 搜索和检索

### 获取所有笔记
```javascript
skill.getAll()
```

### 按项目筛选
```javascript
skill.getAll('project-name')
```

### 关键词搜索
```javascript
// 搜索所有笔记
skill.search('关键词')

// 按项目搜索
skill.search('关键词', 'project-name')
```

## 测试结果

所有测试已通过：
- ✅ 上下文分析功能
- ✅ 项目识别功能
- ✅ 搜索功能
- ✅ 获取笔记功能
- ✅ 云存储上传功能
- ✅ 本地同步功能
- ✅ 按项目组织功能

### 同步状态

**成功同步到云端**：
```json
{
  "success": true,
  "message": "上下文已整理并同步到云端和本地（项目：project-name）",
  "gistUrl": "https://gist.github.com/...",
  "projectName": "project-name",
  "syncStatus": "success"
}
```

**仅保存到本地（Gist 失败）**：
```json
{
  "success": true,
  "message": "上下文已整理并保存到本地，但同步到 Gist 失败：网络错误",
  "projectName": "project-name",
  "syncStatus": "local-only"
}
```

## 故障排除

### 问题：npm install 失败
**解决方案**：
- 确保已安装 Node.js 和 npm
- 检查网络连接

### 问题：上传失败
**解决方案**：
1. 检查网络连接
2. 验证 GitHub Token 是否有效
3. 确认 Token 有 gist 权限
4. **即使上传失败，本地笔记仍可正常使用**

### 问题：找不到技能
**解决方案**：
1. 确认技能目录在正确位置
2. 检查 `.trae/config.json` 配置
3. 重启 TRAE CN

### 问题：GitHub Gist 无法访问
**解决方案**：
1. **这是正常现象，技能会自动降级为本地存储**
2. 检查返回消息中的 `syncStatus` 字段
3. 如果 `syncStatus` 为 `local-only`，说明已保存到本地
4. 本地笔记可以正常使用，不受影响

### 问题：目录不存在
**解决方案**：
- 技能会自动创建，无需手动创建

### 问题：需要重启 TRAE 吗？
**解决方案**：
- 修改 `.env` 后重新运行技能即可

## 下一步

1. **在 TRAE CN 中启用技能**
   - 确保 `.trae/config.json` 配置正确
   - 重启 TRAE CN

2. **测试技能**
   - 在 TRAE CN 中输入"整理上下文"
   - 查看是否成功生成笔记

3. **查看笔记**
   - 访问您的 GitHub Gist 页面
   - 查看生成的上下文笔记

## 开发者信息

- 版本：1.1.0
- 创建日期：2026-03-18
- 许可证：MIT
- GitHub：https://github.com/ethanhuangcst/trae-context-gist
