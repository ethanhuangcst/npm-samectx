#!/bin/bash

# trae-context-gist 全局部署脚本

set -e

echo "======================================"
echo "  trae-context-gist 全局部署工具"
echo "======================================"
echo ""

# 检查 Git
if ! command -v git &> /dev/null; then
    echo "❌ 错误：未找到 Git，请先安装 Git"
    exit 1
fi

# 检查 Node.js
if ! command -v node &> /dev/null; then
    echo "❌ 错误：未找到 Node.js，请先安装 Node.js"
    exit 1
fi

# 检查 npm
if ! command -v npm &> /dev/null; then
    echo "❌ 错误：未找到 npm，请先安装 npm"
    exit 1
fi

# 创建全局目录
echo "📁 创建全局目录..."
mkdir -p ~/.trae/skills
mkdir -p ~/.trae/bin

# 检查是否已安装
if [ -d ~/.trae/skills/trae-context-gist ]; then
    echo "⚠️  检测到已安装，正在更新..."
    cd ~/.trae/skills/trae-context-gist
    git pull origin main
else
    echo "📥 克隆技能到全局目录..."
    git clone https://github.com/ethanhuangcst/trae-context-gist.git ~/.trae/skills/trae-context-gist
    cd ~/.trae/skills/trae-context-gist
fi

# 安装依赖
echo "📦 安装依赖..."
npm install

# 配置 GitHub Token
if [ ! -f .env ]; then
    echo ""
    echo "🔑 配置 GitHub Token"
    echo "请访问：https://github.com/settings/tokens"
    echo "创建 Token 时需要选择 'gist' 权限"
    echo ""
    read -p "请输入您的 GitHub Token: " token
    
    cat > .env << EOF
# GitHub Token Configuration
GITHUB_TOKEN=$token
EOF
    
    chmod 600 .env
    echo "✅ GitHub Token 已配置"
else
    echo "✅ GitHub Token 已存在"
fi

# 创建全局配置文件
echo ""
echo "📝 创建全局配置文件..."
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

# 创建项目初始化脚本
echo "📝 创建项目初始化脚本..."
cat > ~/.trae/bin/init-project.sh << 'SCRIPT'
#!/bin/bash

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
ln -sf ~/.trae/skills/trae-context-gist "$PROJECT_DIR/.trae/skills/trae-context-gist"

echo "✅ 项目初始化完成！"
echo "💡 在 TRAE 中输入 '整理上下文' 测试技能"
SCRIPT

chmod +x ~/.trae/bin/init-project.sh

# 添加 shell 别名
SHELL_RC=""
if [ -f ~/.zshrc ]; then
    SHELL_RC=~/.zshrc
elif [ -f ~/.bashrc ]; then
    SHELL_RC=~/.bashrc
fi

if [ -n "$SHELL_RC" ]; then
    if ! grep -q "trae-init" "$SHELL_RC"; then
        echo "" >> "$SHELL_RC"
        echo "# TRAE 全局技能" >> "$SHELL_RC"
        echo "alias trae-init='~/.trae/bin/init-project.sh'" >> "$SHELL_RC"
        echo "✅ 已添加 shell 别名 'trae-init'"
    fi
fi

echo ""
echo "======================================"
echo "  ✅ 全局部署完成！"
echo "======================================"
echo ""
echo "📁 全局目录：~/.trae/"
echo "🔧 技能位置：~/.trae/skills/trae-context-gist"
echo "⚙️  配置文件：~/.trae/config.json"
echo ""
echo "使用方法："
echo ""
echo "1. 在新项目中初始化："
echo "   cd /path/to/new/project"
echo "   ~/.trae/bin/init-project.sh"
echo ""
echo "2. 或使用别名（重新打开终端后）："
echo "   cd /path/to/new/project"
echo "   trae-init"
echo ""
echo "3. 在 TRAE 中测试："
echo "   输入 '整理上下文'"
echo ""
echo "📖 详细文档："
echo "   https://github.com/ethanhuangcst/trae-context-gist"
echo ""
