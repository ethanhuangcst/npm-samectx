#!/bin/bash

# trae-context-gist 傻瓜式快速配置脚本
# 使用符号链接实现多项目共享

set -e

echo "======================================"
echo "  trae-context-gist 快速配置向导"
echo "======================================"
echo ""

PROJECT_DIR=$(pwd)

# 步骤 1：检查全局技能是否已安装
echo "📦 步骤 1/4：检查全局技能..."
if [ ! -d ~/.trae/skills/trae-context-gist ]; then
    echo "❌ 全局技能未安装，正在安装..."
    mkdir -p ~/.trae/skills
    git clone https://github.com/ethanhuangcst/trae-context-gist.git ~/.trae/skills/trae-context-gist
    echo "✅ 全局技能已安装"
else
    echo "✅ 全局技能已存在"
    
    # 更新全局技能
    echo "🔄 更新全局技能..."
    cd ~/.trae/skills/trae-context-gist
    git pull origin main || true
fi

# 步骤 2：检查 GitHub Token
echo ""
echo "🔑 步骤 2/4：配置 GitHub Token..."

# 检查全局技能目录中的 .env 文件
if [ -f ~/.trae/skills/trae-context-gist/.env ]; then
    # 检查是否有有效的 token
    if grep -q "GITHUB_TOKEN=ghp_\|GITHUB_TOKEN=github_pat_" ~/.trae/skills/trae-context-gist/.env; then
        echo "✅ 检测到已配置的 GitHub Token"
        read -p "是否要更新 Token？(y/n) " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "⏭️  跳过 Token 配置"
            SKIP_TOKEN=true
        fi
    fi
fi

if [ "$SKIP_TOKEN" != true ]; then
    echo ""
    echo "📋 请按照以下步骤获取 GitHub Token："
    echo ""
    echo "1️⃣  点击以下链接（会自动打开浏览器）："
    echo "    https://github.com/settings/tokens/new"
    echo ""
    echo "2️⃣  填写表单："
    echo "    - Note: trae-context-gist"
    expiration_date=$(date -v+1y +%Y-%m-%d 2>/dev/null || date -d "+1 year" +%Y-%m-%d 2>/dev/null || echo "2025-12-31")
    echo "    - Expiration: Custom → $expiration_date"
    echo "    - Select scopes: ✅ gist"
    echo ""
    echo "3️⃣  点击 'Generate token'"
    echo ""
    echo "4️⃣  复制生成的 Token（以 ghp_ 或 github_pat_ 开头）"
    echo ""
    
    # 尝试打开浏览器
    read -p "按 Enter 打开浏览器获取 Token..." -r
    if command -v open &> /dev/null; then
        open "https://github.com/settings/tokens/new"
    elif command -v xdg-open &> /dev/null; then
        xdg-open "https://github.com/settings/tokens/new"
    else
        echo "请手动打开：https://github.com/settings/tokens/new"
    fi
    
    echo ""
    read -p "请粘贴您的 GitHub Token: " token
    
    # 验证 token 格式
    if [[ ! $token =~ ^(ghp_|github_pat_) ]]; then
        echo "⚠️  Token 格式可能不正确，但继续配置..."
    fi
    
    # 写入 .env 文件
    mkdir -p ~/.trae/skills/trae-context-gist
    cat > ~/.trae/skills/trae-context-gist/.env << EOF
# GitHub Token Configuration
GITHUB_TOKEN=$token
EOF
    chmod 600 ~/.trae/skills/trae-context-gist/.env
    echo "✅ GitHub Token 已保存到全局目录"
fi

# 步骤 3：安装依赖
echo ""
echo "📦 步骤 3/4：安装依赖..."
cd ~/.trae/skills/trae-context-gist
if [ ! -d node_modules ]; then
    npm install
    echo "✅ 依赖安装完成"
else
    echo "✅ 依赖已存在"
fi

# 步骤 4：创建项目配置（使用符号链接）
echo ""
echo "📄 步骤 4/4：配置项目技能..."
cd "$PROJECT_DIR"

# 创建项目技能目录
mkdir -p .trae/skills

# 删除旧的符号链接或目录
if [ -L .trae/skills/trae-context-gist ]; then
    rm .trae/skills/trae-context-gist
elif [ -d .trae/skills/trae-context-gist ]; then
    rm -rf .trae/skills/trae-context-gist
fi

# 创建符号链接
ln -s ~/.trae/skills/trae-context-gist .trae/skills/trae-context-gist
echo "✅ 已创建符号链接到全局技能目录"

# 创建配置文件（使用相对路径）
cat > .trae/config.json << 'EOF'
{
  "skills": [
    {
      "name": "trae-context-gist",
      "path": "./skills/trae-context-gist",
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

echo "✅ 项目配置已创建"

# 完成
echo ""
echo "======================================"
echo "  ✅ 配置完成！"
echo "======================================"
echo ""
echo "📁 项目目录：$PROJECT_DIR"
echo "📄 配置文件：.trae/config.json"
echo "🔗 技能链接：.trae/skills/trae-context-gist -> ~/.trae/skills/trae-context-gist"
echo "🔑 Token 文件：~/.trae/skills/trae-context-gist/.env（全局共享）"
echo ""
echo "✨ 优势："
echo "  - 只需维护一份技能文件"
echo "  - 更新全局目录，所有项目自动更新"
echo "  - GitHub Token 只需配置一次"
echo ""
echo "🎉 现在可以在 TRAE 中使用："
echo "   输入 '整理上下文' 测试技能"
echo ""
echo "📖 更多信息："
echo "   https://github.com/ethanhuangcst/trae-context-gist"
echo ""
