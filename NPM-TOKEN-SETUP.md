# 🔑 NPM Token设置详细指南

## 步骤1：生成NPM访问令牌

### 1.1 访问NPM网站
- 打开浏览器，访问 https://www.npmjs.com
- 点击右上角"Sign In"登录您的NPM账户
- 如果没有账户，先点击"Sign Up"注册

### 1.2 生成访问令牌
1. **进入Token管理页面**
   - 登录后，点击右上角的头像
   - 从下拉菜单中选择"Access Tokens"
   - 或直接访问：https://www.npmjs.com/settings/tokens

2. **创建新令牌**
   - 点击"Generate New Token"按钮
   - 选择令牌类型：**"Automation"**（用于CI/CD自动化）
   - 不要选择"Publish"（权限过大）

3. **复制令牌**
   - 令牌生成后会显示一长串字符（如：npm_xxxxxxxxxxxxxxxxxxxxxx）
   - **立即复制并保存**（只显示一次！）
   - 建议保存到安全的地方

## 步骤2：在GitHub中配置NPM Token

### 2.1 访问GitHub仓库设置
1. 访问您的仓库：https://github.com/timtoday/mcp-windows-notify
2. 点击仓库页面上方的"Settings"标签
3. 在左侧菜单中找到"Secrets and variables"
4. 点击"Actions"

### 2.2 添加Repository Secret
1. 点击"New repository secret"按钮
2. 填写信息：
   - **Name**: `NPM_TOKEN`（必须完全一致）
   - **Secret**: 粘贴您刚才复制的NPM令牌
3. 点击"Add secret"

### 2.3 验证设置
- 添加成功后，您会在Secrets列表中看到"NPM_TOKEN"
- 值会显示为"***"（已加密）

## 步骤3：创建GitHub Release触发自动发布

### 3.1 更新版本号（可选）
如果您想发布为v1.0.1而不是v1.0.0：
```bash
cd /path/to/mcp_windows_notify
npm version patch
git push --tags
```

### 3.2 创建Release
1. **访问Releases页面**
   - 访问：https://github.com/timtoday/mcp-windows-notify/releases
   - 点击"Create a new release"

2. **填写Release信息**
   - **Choose a tag**: 
     - 如果已有标签：选择"v1.0.0"
     - 如果没有标签：输入"v1.0.0"，选择"Create new tag: v1.0.0 on publish"
   - **Release title**: `v1.0.0 - Initial Release`
   - **Description**:
     ```markdown
     ## 🎉 MCP Windows通知插件首次发布！
     
     ### ✨ 主要功能
     - Windows原生系统通知支持
     - MCP协议完整实现
     - 支持npx直接使用：`npx -y mcp-windows-notify`
     - 多种通知类型（信息、警告、错误、成功）
     - 可配置声音和显示时长
     
     ### 🚀 使用方法
     在您的MCP配置中添加：
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
     
     ### 📦 安装方式
     - 直接使用：`npx mcp-windows-notify`
     - 全局安装：`npm install -g mcp-windows-notify`
     ```

3. **发布Release**
   - 确保"Set as the latest release"已勾选
   - 点击"Publish release"

## 步骤4：监控自动发布过程

### 4.1 查看GitHub Actions
1. 访问：https://github.com/timtoday/mcp-windows-notify/actions
2. 您会看到"Publish to NPM"工作流正在运行
3. 点击查看详细日志

### 4.2 检查发布状态
- ✅ 绿色勾号：发布成功
- ❌ 红色叉号：发布失败（查看日志排查问题）

### 4.3 验证NPM包
发布成功后：
1. 访问：https://www.npmjs.com/package/mcp-windows-notify
2. 检查包信息是否正确
3. 测试安装：`npx mcp-windows-notify@latest`

## 🔧 故障排除

### NPM Token问题
- **错误**: "Invalid token"
  - **解决**: 重新生成NPM令牌，确保选择"Automation"类型
  - **检查**: GitHub Secrets中的NPM_TOKEN是否正确设置

### 发布权限问题
- **错误**: "You do not have permission to publish"
  - **解决**: 确保NPM账户有发布权限
  - **检查**: 包名是否已被其他人占用

### GitHub Actions失败
- **错误**: "npm publish failed"
  - **解决**: 检查package.json中的版本号是否已存在
  - **检查**: 确保所有必需文件都已提交

## 📞 需要帮助？

如果遇到问题，请：
1. 检查GitHub Actions的详细日志
2. 确认NPM Token设置正确
3. 验证package.json配置
4. 检查网络连接

完成这些步骤后，您的插件就会自动发布到NPM，用户可以通过`npx mcp-windows-notify`直接使用！
