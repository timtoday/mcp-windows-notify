# 🚀 发布到GitHub和NPM完整指南

本指南将帮助您将MCP Windows通知插件发布到GitHub和NPM，让其他用户可以通过 `npx mcp-windows-notify` 直接使用。

## 📋 准备工作

### 1. 账户准备
- ✅ GitHub账户
- ✅ NPM账户（在 https://www.npmjs.com 注册）

### 2. 环境检查
运行测试脚本确保环境正常：
```powershell
.\test-publish.ps1 -TestOnly
```

## 🔧 发布步骤

### 步骤1：创建GitHub仓库

1. **在GitHub上创建新仓库**
   - 仓库名：`mcp-windows-notify`
   - 设为公开仓库
   - 不要初始化README（我们已经有了）

2. **更新package.json中的URL**
   已更新为timtoday用户名：
   ```json
   {
     "repository": {
       "url": "git+https://github.com/timtoday/mcp-windows-notify.git"
     },
     "homepage": "https://github.com/timtoday/mcp-windows-notify#readme",
     "bugs": {
       "url": "https://github.com/timtoday/mcp-windows-notify/issues"
     }
   }
   ```

3. **推送代码到GitHub**
   ```bash
   git init
   git add .
   git commit -m "Initial commit: MCP Windows Notify plugin"
   git branch -M main
   git remote add origin https://github.com/timtoday/mcp-windows-notify.git
   git push -u origin main
   ```

### 步骤2：配置NPM发布

1. **登录NPM**
   ```bash
   npm login
   ```

2. **生成NPM访问令牌**
   - 访问 https://www.npmjs.com/settings/tokens
   - 创建新的访问令牌（选择"Automation"类型）
   - 复制令牌

3. **在GitHub中设置Secrets**
   - 进入GitHub仓库 Settings > Secrets and variables > Actions
   - 添加新的repository secret：
     - Name: `NPM_TOKEN`
     - Value: 您的NPM访问令牌

### 步骤3：发布

#### 方法A：自动发布（推荐）

1. **更新版本并创建标签**
   ```bash
   npm version patch  # 或 minor, major
   git push --tags
   ```

2. **在GitHub上创建Release**
   - 访问 `https://github.com/timtoday/mcp-windows-notify/releases`
   - 点击"Create a new release"
   - 选择刚创建的标签（如v1.0.1）
   - 填写发布标题和说明
   - 点击"Publish release"

3. **GitHub Actions自动执行**
   - 运行CI测试
   - 构建项目
   - 发布到NPM
   - 创建发布资产

#### 方法B：手动发布

```bash
# 构建项目
npm run build

# 发布到NPM
npm publish
```

## ✅ 验证发布

发布成功后，验证用户可以正常使用：

1. **测试NPM包**
   ```bash
   npx mcp-windows-notify@latest
   ```

2. **测试MCP配置**
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

## 📊 发布后的维护

### 版本管理
- 使用语义化版本控制
- 主版本：不兼容的API更改
- 次版本：向后兼容的功能添加
- 修订版本：向后兼容的问题修复

### 更新发布
1. 修改代码
2. 运行测试：`.\test-publish.ps1`
3. 更新版本：`npm version patch`
4. 推送：`git push --tags`
5. 创建新的GitHub Release

## 🎯 用户使用方式

发布成功后，用户可以通过以下方式使用您的插件：

### 直接使用（推荐）
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

### 全局安装后使用
```bash
npm install -g mcp-windows-notify
```

```json
{
  "mcpServers": {
    "windows-notify": {
      "command": "mcp-windows-notify"
    }
  }
}
```

## 🔍 故障排除

### 发布失败
- 检查NPM_TOKEN是否正确设置
- 确保包名在NPM上可用
- 检查网络连接

### CI失败
- 检查GitHub Actions日志
- 确保所有文件都已提交
- 验证TypeScript编译无错误

## 🎉 完成！

恭喜！您的MCP Windows通知插件现在已经发布，其他用户可以通过 `npx mcp-windows-notify` 直接使用了！
