# 🔔 醒目通知功能使用指南

## 🎯 新功能概述

v1.1.0版本大幅增强了通知的醒目程度和用户体验：

### ✨ 主要改进
- **🔒 常驻通知** - 通知会一直显示直到用户主动关闭
- **🔊 增强音效** - 双重提示音，确保用户注意到
- **🎨 醒目设计** - emoji图标、格式化文本、操作按钮
- **👆 交互式** - 提供多种操作选择（确定、关闭、稍后提醒）

## 🛠️ 新增工具

### 1. notify_ai_work_complete
**专为AI工作完成设计的醒目通知**
```json
{
  "tool": "notify_ai_work_complete",
  "arguments": {
    "workType": "代码生成",
    "details": "已成功生成React组件，包含TypeScript类型定义"
  }
}
```

**效果**：
```
🤖 AI工作完成！
🎯 代码生成已完成
📊 已成功生成React组件，包含TypeScript类型定义

🔔 请查看结果并继续您的工作
👆 点击确定关闭通知

[✅ 查看结果] [⏰ 稍后查看] [❌ 关闭]
```

### 2. notify_dev_tool_status
**开发工具状态通知**
```json
{
  "tool": "notify_dev_tool_status",
  "arguments": {
    "status": "success",
    "message": "代码格式化完成，所有文件已优化"
  }
}
```

**效果**：
```
✅ 开发工具状态
✅ 代码格式化完成，所有文件已优化

👆 点击确定继续
```

### 3. send_urgent_notification
**自定义醒目通知**
```json
{
  "tool": "send_urgent_notification",
  "arguments": {
    "title": "🚨 重要提醒",
    "message": "您的AI助手已完成所有任务，请查看结果",
    "icon": "warning",
    "sound": true
  }
}
```

## 🎨 增强的原有工具

### notify_task_complete（增强版）
```
🎉 任务完成！
✅ 代码重构
📋 已成功重构用户认证模块

👆 点击确定继续工作

[✅ 确定] [❌ 关闭] [⏰ 稍后提醒]
```

### notify_error（增强版）
```
❌ 发生错误！
🚨 编译失败
📝 发现3个TypeScript类型错误

👆 请检查并处理错误

[✅ 确定] [❌ 关闭] [⏰ 稍后提醒]
```

### notify_reminder（增强版）
```
💡 重要提醒
📢 请检查新增的API接口文档
📌 需要您的确认和审核

👆 点击确定已知悉

[✅ 确定] [❌ 关闭] [⏰ 稍后提醒]
```

## ⚙️ 配置选项

### 环境变量配置
```env
# 通知标题（带emoji）
NOTIFICATION_TITLE=🤖 AI助手通知

# 声音提醒（默认开启）
NOTIFICATION_SOUND=true

# 通知超时时间（0=常驻，>0=自动消失）
NOTIFICATION_TIMEOUT=0

# 通知图标类型
NOTIFICATION_ICON=info
```

### MCP配置示例
```json
{
  "mcpServers": {
    "windows-notify": {
      "command": "npx",
      "args": ["-y", "mcp-windows-notify"],
      "env": {
        "NOTIFICATION_TITLE": "🤖 Claude助手",
        "NOTIFICATION_TIMEOUT": "0",
        "NOTIFICATION_SOUND": "true"
      }
    }
  }
}
```

## 🧪 测试新功能

运行测试脚本体验所有新功能：
```powershell
.\test-urgent-notifications.ps1
```

## 💡 使用建议

### 适用场景
- **AI代码生成完成** - 使用 `notify_ai_work_complete`
- **长时间任务完成** - 使用增强版 `notify_task_complete`
- **重要错误提醒** - 使用增强版 `notify_error`
- **开发工具状态** - 使用 `notify_dev_tool_status`
- **自定义重要通知** - 使用 `send_urgent_notification`

### 最佳实践
1. **重要任务** - 使用常驻通知（timeout=0）
2. **一般提醒** - 可设置自动消失时间
3. **错误通知** - 建议常驻，确保用户看到
4. **成功通知** - 可以适当缩短显示时间

## 🔄 升级说明

如果您已经在使用旧版本：

1. **更新包**：
   ```bash
   npm update -g mcp-windows-notify
   # 或使用npx自动获取最新版本
   ```

2. **更新配置**：
   - 设置 `NOTIFICATION_TIMEOUT=0` 启用常驻通知
   - 确保 `NOTIFICATION_SOUND=true` 开启声音

3. **测试新功能**：
   - 运行测试脚本验证效果
   - 体验新的通知工具

## 🎉 效果展示

新版本的通知将会：
- 🔊 **播放双重提示音** - 确保引起注意
- 📌 **常驻屏幕** - 直到用户主动关闭
- 🎨 **醒目设计** - emoji图标和格式化文本
- 👆 **交互式按钮** - 提供多种操作选择
- ⚡ **即时响应** - 快速传达AI工作状态

现在您的AI助手完成任务后，您绝对不会错过任何重要通知！🚀
