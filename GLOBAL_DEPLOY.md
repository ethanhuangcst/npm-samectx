# 全局技能部署指南

## 方法一：全局配置文件（推荐）✨

### 1. 创建全局 TRAE 配置目录

```bash
# 创建全局配置目录
mkdir -p ~/.trae/skills

# 克隆技能到全局目录
git clone https://github.com/ethanhuangcst/trae-context-gist.git ~/.trae/skills/trae-context-gist

# 安装依赖
cd ~/.trae/skills/trae-context-gist
npm install

# 配置 GitHub Token
cp .env.example .env
nano .env  # 添加 GITHUB_TOKEN
```

### 2. 创建全局配置文件

```bash
# 创建全局配置文件
cat > ~/.trae/config.json << 'EOF'
{
  "skills": [
    {
      "name": "trae-context-gist",
      "path": "~/.trae/skills/trae-context-gist",
      "enabled": true,
      "schedule": "hourly",
      "description": "自动整理对话上下文并存储到 GitHub Gist"
    }
  ],
  "contextManagement": {
    "autoSummarize": true,
    "summarizeInterval": "hourly",
    "storageProvider": "github-gist",
    "localIndex": true
  }
}
EOF
```

### 3. 在新项目中引用全局技能

创建新项目时，在项目的 `.trae/config.json` 中引用全局配置：

```json
{
  "extends": "~/.trae/config.json",
  "skills": [
    {
      "name": "trae-context-gist",
      "path": "~/.trae/skills/trae-context-gist",
      "enabled": true
    }
  ]
}
```

## 方法二：项目模板

### 1. 创建项目模板

```bash
# 创建模板目录
mkdir -p ~/.trae/templates/default

# 创建模板配置
cat > ~/.trae/templates/default/.trae/config.json << 'EOF'
{
  "skills": [
    {
      "name": "trae-context-gist",
      "path": "~/.trae/skills/trae-context-gist",
      "enabled": true,
      "schedule": "hourly",
      "description": "自动整理对话上下文并存储到 GitHub Gist"
    }
  ]
}
EOF

# 创建符号链接到技能目录
mkdir -p ~/.trae/templates/default/.trae/skills
ln -s ~/.trae/skills/trae-context-gist ~/.trae/templates/default/.trae/skills/trae-context-gist
```

### 2. 使用模板创建新项目

```bash
# 创建新项目时复制模板
cp -r ~/.trae/templates/default/.trae /path/to/new/project/
```

## 方法三：自动化脚本

### 创建项目初始化脚本

```bash
#!/bin/bash
# 文件：~/.trae/bin/init-project.sh

PROJECT_DIR="${1:-.}"

echo "🚀 初始化 TRAE 项目：$PROJECT_DIR"

# 创建 .trae 目录
mkdir -p "$PROJECT_DIR/.trae/skills"

# 创建配置文件
cat > "$PROJECT_DIR/.trae/config.json" << 'EOF'
{
  "skills": [
    {
      "name": "trae-context-gist",
      "path": "~/.trae/skills/trae-context-gist",
      "enabled": true,
      "schedule": "hourly",
      "description": "自动整理对话上下文并存储到 GitHub Gist"
    }
  ],
  "contextManagement": {
    "autoSummarize": true,
    "summarizeInterval": "hourly",
    "storageProvider": "github-gist",
    "localIndex": true
  }
}
EOF

# 创建符号链接
ln -s ~/.trae/skills/trae-context-gist "$PROJECT_DIR/.trae/skills/trae-context-gist"

echo "✅ 项目初始化完成！"
echo "💡 在 TRAE 中输入 '整理上下文' 测试技能"
```

使用方法：

```bash
# 赋予执行权限
chmod +x ~/.trae/bin/init-project.sh

# 在新项目中使用
cd /path/to/new/project
~/.trae/bin/init-project.sh
```

## 方法四：Shell 别名

### 添加别名到 shell 配置

```bash
# 编辑 shell 配置文件
nano ~/.zshrc  # 或 ~/.bashrc

# 添加以下内容
alias trae-init='~/.trae/bin/init-project.sh'
alias trae-new='mkdir -p .trae/skills && ln -s ~/.trae/skills/trae-context-gist .trae/skills/ && cat > .trae/config.json << '\''EOF'\''{"skills":[{"name":"trae-context-gist","path":"~/.trae/skills/trae-context-gist","enabled":true}]}EOF'

# 重新加载配置
source ~/.zshrc
```

使用方法：

```bash
# 在新项目中初始化
cd /path/to/new/project
trae-init
```

## 方法五：Git 模板

### 创建 Git 模板

```bash
# 创建 Git 模板目录
mkdir -p ~/.git-templates/trae/.trae/skills

# 复制技能配置
cat > ~/.git-templates/trae/.trae/config.json << 'EOF'
{
  "skills": [
    {
      "name": "trae-context-gist",
      "path": "~/.trae/skills/trae-context-gist",
      "enabled": true
    }
  ]
}
EOF

# 创建符号链接
ln -s ~/.trae/skills/trae-context-gist ~/.git-templates/trae/.trae/skills/trae-context-gist

# 配置 Git 使用模板
git config --global init.templatedir ~/.git-templates/trae
```

使用方法：

```bash
# 创建新项目时自动包含技能
mkdir new-project
cd new-project
git init  # 自动应用模板
```

## 目录结构

### 全局目录结构

```
~/.trae/
├── config.json              # 全局配置
├── skills/                  # 全局技能目录
│   └── trae-context-gist/
│       ├── .env            # GitHub Token
│       ├── index.js
│       ├── package.json
│       └── ...
├── templates/               # 项目模板
│   └── default/
│       └── .trae/
│           ├── config.json
│           └── skills/ -> ~/.trae/skills/
└── bin/                     # 工具脚本
    └── init-project.sh
```

### 项目目录结构

```
your-project/
└── .trae/
    ├── config.json         # 引用全局技能
    └── skills/
        └── trae-context-gist -> ~/.trae/skills/trae-context-gist
```

## 验证全局部署

```bash
# 1. 检查全局技能
ls -la ~/.trae/skills/trae-context-gist

# 2. 检查全局配置
cat ~/.trae/config.json

# 3. 在新项目中测试
mkdir /tmp/test-project
cd /tmp/test-project
~/.trae/bin/init-project.sh
cat .trae/config.json
```

## 优势对比

| 方法 | 优势 | 适用场景 |
|------|------|---------|
| 全局配置 | 一次配置，处处可用 | 推荐，最简单 |
| 项目模板 | 可定制多种模板 | 需要多种项目类型 |
| 自动化脚本 | 灵活可控 | 高级用户 |
| Shell 别名 | 快速初始化 | 命令行用户 |
| Git 模板 | Git 项目自动应用 | Git 重度用户 |

## 注意事项

1. **GitHub Token 安全**：
   - 全局 `.env` 文件包含敏感信息
   - 确保权限设置正确：`chmod 600 ~/.trae/skills/trae-context-gist/.env`

2. **技能更新**：
   - 更新全局技能：`cd ~/.trae/skills/trae-context-gist && git pull`
   - 所有项目自动获得更新

3. **版本兼容**：
   - 保持全局技能版本一致
   - 如需不同版本，使用项目级部署

## 快速开始

```bash
# 一键全局部署
curl -fsSL https://raw.githubusercontent.com/ethanhuangcst/trae-context-gist/main/deploy-global.sh | bash
```

---

**推荐方法**：使用方法一（全局配置文件），简单高效，一次配置永久有效！
