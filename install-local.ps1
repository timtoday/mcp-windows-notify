# 本地安装MCP Windows通知插件脚本
Write-Host "安装MCP Windows通知插件..." -ForegroundColor Green

# 检查Node.js是否安装
try {
    $nodeVersion = node --version
    Write-Host "检测到Node.js版本: $nodeVersion" -ForegroundColor Yellow
} catch {
    Write-Host "错误: 未检测到Node.js，请先安装Node.js 18.0.0或更高版本" -ForegroundColor Red
    exit 1
}

# 构建项目
Write-Host "构建项目..." -ForegroundColor Cyan
npm run build

if ($LASTEXITCODE -ne 0) {
    Write-Host "构建失败!" -ForegroundColor Red
    exit 1
}

# 全局安装到本地
Write-Host "全局安装插件..." -ForegroundColor Cyan
npm install -g .

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ 安装成功!" -ForegroundColor Green
    Write-Host ""
    Write-Host "现在您可以在MCP配置中使用以下配置:" -ForegroundColor Yellow
    Write-Host @"
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
"@ -ForegroundColor White
    Write-Host ""
    Write-Host "或者直接使用命令测试:" -ForegroundColor Yellow
    Write-Host "mcp-windows-notify" -ForegroundColor White
} else {
    Write-Host "安装失败!" -ForegroundColor Red
    exit 1
}
