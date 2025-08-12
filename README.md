# Windows通知MCP插件

[![NPM Version](https://img.shields.io/npm/v/mcp-windows-notify)](https://www.npmjs.com/package/mcp-windows-notify)
[![GitHub License](https://img.shields.io/github/license/timtoday/mcp-windows-notify)](https://github.com/timtoday/mcp-windows-notify/blob/main/LICENSE)
[![CI](https://github.com/timtoday/mcp-windows-notify/workflows/CI/badge.svg)](https://github.com/timtoday/mcp-windows-notify/actions)

一个专为Windows环境设计的MCP（Model Context Protocol）插件，支持在AI开发工具最小化时通过系统通知提醒用户任务完成状态。

## 快速开始

直接在您的MCP配置中使用，无需预先安装：

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

## 功能特性

- 🔔 Windows原生系统通知支持
- 🎨 多种通知图标类型（信息、警告、错误、成功）
- 🔊 可配置声音提醒
- ⏰ 自定义通知显示时长
- 🛠️ 多种预设通知类型（任务完成、错误提醒、一般提醒）
- ⚙️ 环境变量配置支持

## 安装方法

### 方法一：NPX（推荐）
无需预先安装，直接在MCP配置中使用：
```bash
npx mcp-windows-notify
```

### 方法二：全局安装
```bash
npm install -g mcp-windows-notify
```

### 方法三：从源码安装
```bash
git clone https://github.com/timtoday/mcp-windows-notify.git
cd mcp-windows-notify
npm install
npm run build
npm install -g .
```

## 配置

复制 `.env.example` 为 `.env` 并根据需要修改配置：

```env
# Windows通知配置
NOTIFICATION_TITLE=AI助手通知
NOTIFICATION_SOUND=true
NOTIFICATION_TIMEOUT=5000
NOTIFICATION_ICON=info

# MCP服务器配置
MCP_SERVER_NAME=windows-notify
MCP_SERVER_VERSION=1.0.0
```

## 使用方法

### 在AI开发工具中配置

在你的AI开发工具（如Claude Desktop、Cursor等）的MCP配置中添加：

#### 使用npx（推荐）
```json
{
  "mcpServers": {
    "windows-notify": {
      "command": "npx",
      "args": ["-y", "mcp-windows-notify"],
      "env": {
        "NOTIFICATION_TITLE": "AI助手通知",
        "NOTIFICATION_SOUND": "true",
        "NOTIFICATION_TIMEOUT": "5000",
        "NOTIFICATION_ICON": "info"
      }
    }
  }
}
```

#### 使用本地安装版本
```json
{
  "mcpServers": {
    "windows-notify": {
      "command": "mcp-windows-notify",
      "env": {
        "NOTIFICATION_TITLE": "AI助手通知",
        "NOTIFICATION_SOUND": "true",
        "NOTIFICATION_TIMEOUT": "5000",
        "NOTIFICATION_ICON": "info"
      }
    }
  }
}
```

## 可用工具

### 1. send_notification
发送自定义Windows系统通知

**参数：**
- `message` (必需): 通知消息内容
- `title` (可选): 通知标题
- `icon` (可选): 图标类型 (`info`, `warning`, `error`, `success`)
- `sound` (可选): 是否播放声音
- `timeout` (可选): 显示时长（毫秒）
- `subtitle` (可选): 副标题

### 2. notify_task_complete
发送任务完成通知

**参数：**
- `taskName` (必需): 任务名称
- `details` (可选): 任务详情

### 3. notify_error
发送错误通知

**参数：**
- `errorMessage` (必需): 错误消息
- `details` (可选): 错误详情

### 4. notify_reminder
发送提醒通知

**参数：**
- `message` (必需): 提醒消息
- `subtitle` (可选): 副标题

## 使用示例

当AI助手完成代码修改后，可以调用：

```javascript
// 任务完成通知
notify_task_complete({
  "taskName": "代码重构完成",
  "details": "已成功重构用户认证模块，请继续开发"
})

// 错误通知
notify_error({
  "errorMessage": "编译失败",
  "details": "发现3个TypeScript类型错误"
})

// 自定义通知
send_notification({
  "title": "开发提醒",
  "message": "请检查新增的API接口文档",
  "icon": "info",
  "sound": true
})
```

## 技术栈

- **Node.js** - 运行环境
- **TypeScript** - 开发语言
- **@modelcontextprotocol/sdk** - MCP协议支持
- **node-notifier** - Windows通知API

## 系统要求

- Windows 10/11
- Node.js 18.0.0+
- PowerShell 5.0+

## 贡献

欢迎贡献代码！请查看 [CONTRIBUTING.md](CONTRIBUTING.md) 了解详细信息。

### 开发
```bash
git clone https://github.com/timtoday/mcp-windows-notify.git
cd mcp-windows-notify
npm install
npm run dev  # 监听文件变化并自动编译
```

### 提交问题
如果您遇到问题或有功能建议，请在 [GitHub Issues](https://github.com/timtoday/mcp-windows-notify/issues) 中提交。

## 支持

- 📖 [文档](https://github.com/timtoday/mcp-windows-notify#readme)
- 🐛 [问题反馈](https://github.com/timtoday/mcp-windows-notify/issues)
- 💬 [讨论](https://github.com/timtoday/mcp-windows-notify/discussions)

## 许可证

MIT License - 查看 [LICENSE](LICENSE) 文件了解详细信息。
