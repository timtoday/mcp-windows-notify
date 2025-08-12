# 🔧 修复Release标签问题

## 问题原因
GitHub Release需要一个有效的Git标签，错误信息表明标签格式不正确或为空。

## 解决方案

### 方法1：通过命令行创建标签（推荐）

1. **在本地项目目录中运行**：
   ```bash
   # 确保在项目根目录
   cd /path/to/mcp_windows_notify
   
   # 创建并推送标签
   git tag v1.0.0
   git push origin v1.0.0
   ```

2. **然后在GitHub上创建Release**：
   - 访问：https://github.com/timtoday/mcp-windows-notify/releases
   - 点击"Create a new release"
   - 在"Choose a tag"下拉菜单中选择"v1.0.0"（现在应该能看到了）
   - 填写其他信息后点击"Publish release"

### 方法2：在GitHub界面直接创建

1. **访问Release页面**：
   https://github.com/timtoday/mcp-windows-notify/releases

2. **点击"Create a new release"**

3. **正确填写标签信息**：
   - 在"Choose a tag"输入框中输入：`v1.0.0`
   - 确保选择"Create new tag: v1.0.0 on publish"
   - **重要**：标签格式必须是 `v1.0.0`，不能有空格或特殊字符

4. **填写Release信息**：
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

5. **发布Release**：
   - 确保"Set as the latest release"已勾选
   - 点击"Publish release"

## 常见标签格式问题

❌ **错误格式**：
- `1.0.0` (缺少v前缀)
- `v 1.0.0` (有空格)
- `version1.0.0` (格式不标准)
- 空白标签

✅ **正确格式**：
- `v1.0.0`
- `v1.0.1`
- `v2.0.0-beta.1`

## 如果仍然有问题

### 检查项目状态
运行以下命令检查：
```bash
# 检查当前标签
git tag -l

# 检查远程仓库
git remote -v

# 检查当前分支
git branch
```

### 强制创建标签
如果上述方法不行，尝试：
```bash
# 删除可能存在的问题标签
git tag -d v1.0.0
git push origin :refs/tags/v1.0.0

# 重新创建标签
git tag -a v1.0.0 -m "Initial release"
git push origin v1.0.0
```

## 验证成功

创建Release成功后：
1. 访问：https://github.com/timtoday/mcp-windows-notify/releases
2. 应该能看到"v1.0.0"的Release
3. GitHub Actions会自动开始运行
4. 约2-3分钟后包会发布到NPM

运行检查脚本验证：
```powershell
.\check-publish-status.ps1
```
