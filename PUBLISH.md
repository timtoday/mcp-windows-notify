# 发布指南

本文档说明如何将MCP Windows通知插件发布到GitHub和NPM。

## 前置条件

1. **GitHub账户** - 用于创建仓库
2. **NPM账户** - 用于发布包到NPM registry
3. **Node.js 18+** - 开发环境
4. **Git** - 版本控制

## 步骤1：创建GitHub仓库

1. 在GitHub上创建新仓库 `mcp-windows-notify`
2. 克隆到本地或推送现有代码：
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin https://github.com/timtoday/mcp-windows-notify.git
   git push -u origin main
   ```

## 步骤2：配置NPM发布

1. **登录NPM**
   ```bash
   npm login
   ```

2. **更新package.json中的仓库信息**
   已更新为timtoday用户名：
   ```json
   {
     "repository": {
       "type": "git",
       "url": "git+https://github.com/timtoday/mcp-windows-notify.git"
     },
     "homepage": "https://github.com/timtoday/mcp-windows-notify#readme"
   }
   ```

## 步骤3：设置GitHub Secrets

在GitHub仓库设置中添加以下Secrets：

1. **NPM_TOKEN** - 您的NPM访问令牌
   - 在NPM网站生成访问令牌
   - 在GitHub仓库 Settings > Secrets and variables > Actions 中添加

## 步骤4：发布流程

### 手动发布
```bash
# 构建项目
npm run build

# 发布到NPM
npm publish
```

### 自动发布（推荐）
1. 更新版本号：
   ```bash
   npm version patch  # 或 minor, major
   ```

2. 推送标签：
   ```bash
   git push --tags
   ```

3. 在GitHub上创建Release：
   - 访问仓库的Releases页面
   - 点击"Create a new release"
   - 选择刚创建的标签
   - 填写发布说明
   - 点击"Publish release"

4. GitHub Actions会自动：
   - 运行CI测试
   - 构建项目
   - 发布到NPM
   - 创建发布资产

## 步骤5：验证发布

发布成功后，用户可以通过以下方式使用：

```bash
# 直接使用npx（推荐）
npx mcp-windows-notify

# 或全局安装
npm install -g mcp-windows-notify
```

## MCP配置示例

用户在AI工具中的配置：
```json
{
  "mcpServers": {
    "windows-notify": {
      "command": "npx",
      "args": ["-y", "mcp-windows-notify"]
    }
  }
}
```

## 版本管理

- 使用语义化版本控制 (SemVer)
- 主版本号：不兼容的API更改
- 次版本号：向后兼容的功能添加
- 修订版本号：向后兼容的问题修复

## 故障排除

### 发布失败
- 检查NPM_TOKEN是否正确设置
- 确保包名在NPM上可用
- 检查package.json格式是否正确

### CI失败
- 检查Node.js版本兼容性
- 确保所有依赖都在package.json中声明
- 检查TypeScript编译错误
