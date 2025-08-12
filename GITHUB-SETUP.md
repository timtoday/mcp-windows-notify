# 🚀 GitHub仓库创建和推送指南

## 步骤1：在GitHub上创建仓库

1. **登录GitHub**
   - 访问 https://github.com
   - 使用您的账号 `timtoday` 登录

2. **创建新仓库**
   - 点击右上角的 "+" 按钮
   - 选择 "New repository"
   - 仓库名称：`mcp-windows-notify`
   - 描述：`Windows notification MCP server for AI development tools`
   - 设为 **Public**（公开仓库）
   - **不要**勾选 "Add a README file"（我们已经有了）
   - **不要**勾选 "Add .gitignore"（我们已经有了）
   - **不要**勾选 "Choose a license"（我们已经有了）
   - 点击 "Create repository"

## 步骤2：推送代码到GitHub

在项目目录中运行推送脚本：

```powershell
.\push-to-github.ps1
```

或者手动执行以下命令：

```bash
# 初始化Git仓库（如果还没有）
git init

# 添加所有文件
git add .

# 提交更改
git commit -m "Initial commit: MCP Windows Notify plugin"

# 设置默认分支
git branch -M main

# 添加远程仓库
git remote add origin https://github.com/timtoday/mcp-windows-notify.git

# 推送到GitHub
git push -u origin main
```

## 步骤3：验证推送成功

1. 访问 https://github.com/timtoday/mcp-windows-notify
2. 确认所有文件都已上传
3. 检查README.md是否正确显示

## 步骤4：配置NPM自动发布（可选）

1. **生成NPM访问令牌**
   - 访问 https://www.npmjs.com/settings/tokens
   - 点击 "Generate New Token"
   - 选择 "Automation" 类型
   - 复制生成的令牌

2. **在GitHub中设置Secrets**
   - 访问 https://github.com/timtoday/mcp-windows-notify/settings/secrets/actions
   - 点击 "New repository secret"
   - Name: `NPM_TOKEN`
   - Value: 粘贴您的NPM令牌
   - 点击 "Add secret"

## 步骤5：发布到NPM

### 自动发布（推荐）
1. 更新版本号：
   ```bash
   npm version patch
   ```
2. 推送标签：
   ```bash
   git push --tags
   ```
3. 在GitHub上创建Release：
   - 访问 https://github.com/timtoday/mcp-windows-notify/releases
   - 点击 "Create a new release"
   - 选择刚创建的标签
   - 填写发布说明
   - 点击 "Publish release"

### 手动发布
```bash
npm login
npm publish
```

## 🎉 完成！

发布成功后，用户可以通过以下方式使用您的插件：

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

## 故障排除

### 推送失败
- 确保GitHub仓库已创建
- 检查网络连接
- 验证Git认证设置

### 权限问题
- 确保您有仓库的推送权限
- 检查SSH密钥或个人访问令牌设置

### NPM发布失败
- 确保NPM_TOKEN正确设置
- 检查包名是否在NPM上可用
- 验证package.json格式正确
