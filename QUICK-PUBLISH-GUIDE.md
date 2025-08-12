# 🚀 快速发布指南 - 5分钟完成NPM发布

## ✅ 操作清单

### 第1步：生成NPM Token（2分钟）
1. 访问 https://www.npmjs.com/settings/tokens
2. 点击"Generate New Token" → 选择"Automation"
3. 复制生成的令牌（npm_xxxxxxxxxx）

### 第2步：配置GitHub Secrets（1分钟）
1. 访问 https://github.com/timtoday/mcp-windows-notify/settings/secrets/actions
2. 点击"New repository secret"
3. Name: `NPM_TOKEN`
4. Value: 粘贴刚才的令牌
5. 点击"Add secret"

### 第3步：创建Release触发发布（2分钟）
1. 访问 https://github.com/timtoday/mcp-windows-notify/releases
2. 点击"Create a new release"
3. 填写信息：
   - **Tag**: `v1.0.0`
   - **Title**: `v1.0.0 - Initial Release`
   - **Description**: 
     ```
     🎉 MCP Windows通知插件首次发布！
     
     使用方法：
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
     ```
4. 点击"Publish release"

### 第4步：验证发布（自动）
- GitHub Actions会自动运行
- 约2-3分钟后包会出现在NPM上
- 运行检查脚本：`.\check-publish-status.ps1`

## 🎯 完成后的效果

用户可以直接使用：
```bash
npx mcp-windows-notify
```

或在MCP配置中：
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

## 🔍 检查发布状态

运行检查脚本：
```powershell
.\check-publish-status.ps1
```

或手动检查：
- NPM包：https://www.npmjs.com/package/mcp-windows-notify
- GitHub Actions：https://github.com/timtoday/mcp-windows-notify/actions

## ❓ 常见问题

**Q: NPM Token在哪里生成？**
A: https://www.npmjs.com/settings/tokens → "Generate New Token" → "Automation"

**Q: GitHub Secrets在哪里设置？**
A: 仓库页面 → Settings → Secrets and variables → Actions → New repository secret

**Q: 如何知道发布成功了？**
A: 1) GitHub Actions显示绿色勾号 2) NPM网站能搜到包 3) `npx mcp-windows-notify`能运行

**Q: 发布失败怎么办？**
A: 查看GitHub Actions日志，通常是NPM Token问题或包名冲突

## 🎉 就这么简单！

按照这4个步骤，您的MCP插件就会自动发布到NPM，全世界的用户都可以通过`npx`直接使用了！
