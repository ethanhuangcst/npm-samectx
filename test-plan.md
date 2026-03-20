# gctx 测试计划

## 测试环境准备

### 前置条件
- Node.js >= 14.0.0
- GitHub Token（需要 gist 权限）
- 测试目录：`~/test-gctx/`

### 获取 GitHub Token
1. 访问 https://github.com/settings/tokens/new
2. Note: `gctx-test`
3. Expiration: 1 年
4. Scopes: ✅ gist
5. 保存 Token

---

## 测试场景 1：全新项目安装

### 目标
验证在全新项目中安装和使用 CLI 工具

### 步骤

```bash
# 1. 创建全新项目目录
mkdir -p ~/test-gctx/new-project
cd ~/test-gctx/new-project

# 2. 初始化 git（可选，模拟真实项目）
git init

# 3. 使用 npx 运行（无需安装）
npx gctx --help

# 4. 配置 Token
npx gctx config --token ghp_your_token_here

# 5. 验证配置
npx gctx config --show

# 6. 初始化项目
npx gctx init

# 7. 同步上下文
npx gctx sync

# 8. 验证笔记目录
ls -la gctx-notes/

# 9. 查看笔记列表
npx gctx list
```

### 预期结果
- [ ] `--help` 显示正确的命令列表
- [ ] `config --token` 成功保存 Token
- [ ] `config --show` 显示 Token 已配置
- [ ] `init` 创建 `gctx-notes/` 目录
- [ ] `sync` 成功同步，返回 Gist URL
- [ ] 笔记文件保存在 `gctx-notes/`
- [ ] `list` 显示笔记列表

---

## 测试场景 2：进行中项目安装

### 目标
验证在已有项目中安装和使用 CLI 工具

### 步骤

```bash
# 1. 使用现有项目（例如 pen.lite）
cd ~/code/pen.lite

# 2. 检查项目状态
ls -la

# 3. 全局安装（方式 1）
npm install -g gctx

# 4. 验证全局安装
which gctx
gctx --version

# 5. 配置 Token（如果未配置）
gctx config --token ghp_your_token_here

# 6. 同步上下文
gctx sync

# 7. 验证笔记目录
ls -la gctx-notes/

# 8. 查看笔记列表
gctx list

# 9. 指定项目名称同步
gctx sync --project pen-lite-custom

# 10. 验证自定义项目名称
gctx list --project pen-lite-custom
```

### 预期结果
- [ ] 全局安装成功
- [ ] `gctx` 命令可用
- [ ] `sync` 成功同步
- [ ] 笔记保存在项目根目录的 `gctx-notes/`
- [ ] `--project` 参数生效，笔记使用自定义项目名

---

## 测试场景 3：命令详细测试

### 3.1 `--help` 命令

```bash
npx gctx --help
npx gctx sync --help
npx gctx list --help
npx gctx config --help
```

**预期结果：**
- [ ] 显示正确的使用说明
- [ ] 显示所有可用选项

### 3.2 `--version` 命令

```bash
npx gctx --version
```

**预期结果：**
- [ ] 显示正确的版本号（1.0.0）

### 3.3 `config` 命令

```bash
# 显示配置
npx gctx config --show

# 设置 Token
npx gctx config --token ghp_new_token

# 再次显示配置
npx gctx config --show

# 无参数时显示帮助
npx gctx config
```

**预期结果：**
- [ ] `--show` 显示当前配置状态
- [ ] `--token` 成功保存 Token
- [ ] 更新后的 Token 正确显示
- [ ] 无参数时显示帮助信息

### 3.4 `init` 命令

```bash
# 在新目录测试
mkdir -p ~/test-gctx/init-test
cd ~/test-gctx/init-test

npx gctx init

# 验证创建的文件
ls -la
cat .env.example
```

**预期结果：**
- [ ] 创建 `gctx-notes/` 目录
- [ ] 创建 `.env.example` 文件

### 3.5 `sync` 命令

```bash
# 基本同步
npx gctx sync

# 指定项目名称
npx gctx sync --project test-project

# 指定笔记目录
npx gctx sync --dir ./custom-notes

# 验证目录
ls -la gctx-notes/
ls -la custom-notes/
```

**预期结果：**
- [ ] 基本同步成功，返回 Gist URL
- [ ] `--project` 参数生效
- [ ] `--dir` 参数生效，笔记保存在指定目录

### 3.6 `list` 命令

```bash
# 列出所有笔记
npx gctx list

# 筛选项目
npx gctx list --project test-project

# 指定目录
npx gctx list --dir ./custom-notes
```

**预期结果：**
- [ ] 显示所有笔记列表
- [ ] `--project` 筛选生效
- [ ] `--dir` 参数生效

---

## 测试场景 4：错误处理

### 4.1 Token 未配置

```bash
# 临时移除配置
mv ~/.gctx/config.json ~/.gctx/config.json.bak

# 尝试同步
npx gctx sync

# 恢复配置
mv ~/.gctx/config.json.bak ~/.gctx/config.json
```

**预期结果：**
- [ ] 显示错误信息：GitHub Token 未配置
- [ ] 提示运行 `config --token` 命令

### 4.2 无效 Token

```bash
# 设置无效 Token
npx gctx config --token invalid_token

# 尝试同步
npx gctx sync
```

**预期结果：**
- [ ] 显示 Gist 同步失败信息
- [ ] 本地笔记仍然保存成功

### 4.3 空项目目录

```bash
# 在空目录测试
mkdir -p ~/test-gctx/empty-dir
cd ~/test-gctx/empty-dir

npx gctx sync
```

**预期结果：**
- [ ] 使用目录名作为项目名称
- [ ] 同步成功

---

## 测试场景 5：跨工具测试

### 目标
验证在不同 AI 工具中使用 CLI 工具

### 5.1 TRAE CN

```
用户: 请帮我同步上下文
AI: 好的，我来执行同步命令...
[运行] npx gctx sync
[结果] 上下文已同步到 Gist: https://gist.github.com/xxx
```

### 5.2 Cursor

```
用户: 请帮我同步上下文
AI: 好的，我来执行同步命令...
[运行] npx gctx sync
[结果] 上下文已同步到 Gist: https://gist.github.com/xxx
```

### 5.3 Claude Code

```
用户: 请帮我同步上下文
AI: 好的，我来执行同步命令...
[运行] npx gctx sync
[结果] 上下文已同步到 Gist: https://gist.github.com/xxx
```

**预期结果：**
- [ ] 各工具都能正确执行命令
- [ ] 返回 Gist URL
- [ ] 笔记保存在正确位置

---

## 测试清单汇总

| 测试项 | 状态 | 备注 |
|--------|------|------|
| 全新项目安装 | ⬜ | |
| 进行中项目安装 | ⬜ | |
| `--help` 命令 | ⬜ | |
| `--version` 命令 | ⬜ | |
| `config --show` | ⬜ | |
| `config --token` | ⬜ | |
| `init` 命令 | ⬜ | |
| `sync` 基本同步 | ⬜ | |
| `sync --project` | ⬜ | |
| `sync --dir` | ⬜ | |
| `list` 命令 | ⬜ | |
| `list --project` | ⬜ | |
| Token 未配置错误 | ⬜ | |
| 无效 Token 错误 | ⬜ | |
| TRAE CN 集成 | ⬜ | |
| Cursor 集成 | ⬜ | |
| Claude Code 集成 | ⬜ | |

---

## 测试完成后

```bash
# 清理测试目录
rm -rf ~/test-gctx

# 卸载全局安装（如需要）
npm uninstall -g gctx

# 清理配置（如需要）
rm -rf ~/.gctx
```
