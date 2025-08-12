# Windows通知MCP服务器启动脚本
Write-Host "启动Windows通知MCP服务器..." -ForegroundColor Green

# 设置环境变量
$env:NOTIFICATION_TITLE = "AI助手通知"
$env:NOTIFICATION_SOUND = "true"
$env:NOTIFICATION_TIMEOUT = "5000"
$env:NOTIFICATION_ICON = "info"
$env:MCP_SERVER_NAME = "windows-notify"
$env:MCP_SERVER_VERSION = "1.0.0"

# 启动服务器
Write-Host "服务器配置:" -ForegroundColor Yellow
Write-Host "  通知标题: $env:NOTIFICATION_TITLE"
Write-Host "  播放声音: $env:NOTIFICATION_SOUND"
Write-Host "  显示时长: $env:NOTIFICATION_TIMEOUT ms"
Write-Host "  图标类型: $env:NOTIFICATION_ICON"
Write-Host ""
Write-Host "启动MCP服务器 (按Ctrl+C停止)..." -ForegroundColor Cyan

node dist/index.js
