# 快速部署指南

## 方法一：使用 Git（推荐）

### 1. 克隆仓库

```bash
# 在任何位置克隆
git clone https://github.com/ethanhuangcst/trae-context-gist.git ~/temp-deploy
```

### 2. 复制到新项目

```bash
# 复制核心文件到新项目
cp -r ~/temp-deploy/.env.example \
      ~/temp-deploy/SKILL.md \
      ~/temp-deploy/index.js \
      ~/temp-deploy/package.json \
      ~/temp-deploy/package-lock.json \
      ~/temp-deploy/README.md \
      /path/to/new/project/.trae/skills/trae-context-gist/
```

### 3. 安装和配置

```bash
cd /path/to/new/project/.trae/skills/trae-context-gist

# 安装依赖
npm install

# 配置 GitHub Token
cp .env.example .env
nano .env  # 添加 GITHUB_TOKEN=your_token_here
```

### 4. 清理

```bash
rm -rf ~/temp-deploy
```

## 方法二：一键部署脚本

### macOS/Linux

```bash
#!/bin/bash

# 设置目标目录
TARGET_DIR="$1"

if [ -z "$TARGET_DIR" ]; then
    echo "用法：./deploy.sh /path/to/new/project"
    exit 1
fi

SKILL_DIR="$TARGET_DIR/.trae/skills/trae-context-gist"

echo "📦 部署 trae-context-gist 技能到：$SKILL_DIR"

# 创建目录
mkdir -p "$SKILL_DIR"

# 复制文件
cp .env.example "$SKILL_DIR/"
cp SKILL.md "$SKILL_DIR/"
cp index.js "$SKILL_DIR/"
cp package.json "$SKILL_DIR/"
cp package-lock.json "$SKILL_DIR/"
cp README.md "$SKILL_DIR/"

echo "✅ 文件复制完成"

# 安装依赖
echo "📥 安装依赖..."
cd "$SKILL_DIR"
npm install

echo "✅ 部署完成！"
echo ""
echo "下一步："
echo "1. 编辑 $SKILL_DIR/.env 添加 GITHUB_TOKEN"
echo "2. 在 TRAE 中输入 '整理上下文' 测试"
```

### Windows PowerShell

```powershell
param(
    [string]$TARGET_DIR = $(Read-Host "请输入新项目的路径")
)

if ([string]::IsNullOrEmpty($TARGET_DIR)) {
    Write-Host "用法：.\deploy.ps1 <目标路径>"
    exit 1
}

$SKILL_DIR = Join-Path $TARGET_DIR ".trae/skills/trae-context-gist"

Write-Host "📦 部署 trae-context-gist 技能到：$SKILL_DIR" -ForegroundColor Green

# 创建目录
New-Item -ItemType Directory -Force -Path $SKILL_DIR | Out-Null

# 复制文件
Copy-Item .env.example $SKILL_DIR/
Copy-Item SKILL.md $SKILL_DIR/
Copy-Item index.js $SKILL_DIR/
Copy-Item package.json $SKILL_DIR/
Copy-Item package-lock.json $SKILL_DIR/
Copy-Item README.md $SKILL_DIR/

Write-Host "✅ 文件复制完成" -ForegroundColor Green

# 安装依赖
Write-Host "📥 安装依赖..." -ForegroundColor Yellow
Set-Location $SKILL_DIR
npm install

Write-Host "`n✅ 部署完成！" -ForegroundColor Green
Write-Host "`n下一步：" -ForegroundColor Cyan
Write-Host "1. 编辑 $SKILL_DIR\.env 添加 GITHUB_TOKEN"
Write-Host "2. 在 TRAE 中输入 '整理上下文' 测试"
```

## 方法三：手动复制

### 文件清单

复制以下 6 个文件到新项目目录：

```
.trae/skills/trae-context-gist/
├── .env.example
├── SKILL.md
├── index.js
├── package.json
├── package-lock.json
└── README.md
```

### 部署步骤

```bash
# 1. 进入新项目目录
cd /path/to/new/project

# 2. 创建技能目录
mkdir -p .trae/skills/trae-context-gist

# 3. 复制文件
cp /Users/ethanhuang/code/trae-context-gist.ai/.trae/skills/trae-context-gist/{.env.example,SKILL.md,index.js,package.json,package-lock.json,README.md} \
   .trae/skills/trae-context-gist/

# 4. 安装依赖
cd .trae/skills/trae-context-gist
npm install

# 5. 配置 Token
cp .env.example .env
nano .env  # 添加 GITHUB_TOKEN
```

## 获取 GitHub Token

1. 访问：https://github.com/settings/tokens
2. 点击 "Generate new token (classic)"
3. 填写备注（如：trae-context-gist）
4. 选择权限：✅ gist
5. 点击 "Generate token"
6. 复制 token（只显示一次！）
7. 粘贴到 `.env` 文件中

## 验证部署

在 TRAE 中输入：
```
整理上下文
```

如果看到成功消息（包含本地路径或 Gist 链接），说明部署成功！

## 故障排除

### 问题：npm install 失败
**解决**：确保已安装 Node.js 和 npm
```bash
node --version  # 检查 Node.js
npm --version   # 检查 npm
```

### 问题：找不到技能
**解决**：检查 `.trae/config.json` 配置
```json
{
  "skills": [
    {
      "name": "trae-context-gist",
      "path": "./skills/trae-context-gist",
      "enabled": true
    }
  ]
}
```

### 问题：GitHub Token 未配置
**解决**：检查 `.env` 文件是否存在且包含正确的 Token
```bash
cat .env  # 查看内容
```

## 更多信息

- 📖 [README.md](README.md) - 完整使用说明
- 🔗 [GitHub 仓库](https://github.com/ethanhuangcst/trae-context-gist) - 源代码和更新
