# 自动创建Git标签和GitHub Release
param(
    [string]$Version = "1.0.0",
    [string]$Message = "Initial release"
)

Write-Host "🏷️  创建Release标签和发布" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Cyan

$tagName = "v$Version"

# 检查Git状态
Write-Host "`n📋 检查Git状态..." -ForegroundColor Yellow

# 检查是否在Git仓库中
if (-not (Test-Path ".git")) {
    Write-Host "❌ 当前目录不是Git仓库" -ForegroundColor Red
    Write-Host "请确保在项目根目录中运行此脚本" -ForegroundColor White
    exit 1
}

# 检查是否有未提交的更改
$gitStatus = git status --porcelain
if ($gitStatus) {
    Write-Host "⚠️  检测到未提交的更改:" -ForegroundColor Yellow
    git status --short
    $response = Read-Host "是否继续创建Release？ (y/N)"
    if ($response -ne "y" -and $response -ne "Y") {
        Write-Host "已取消" -ForegroundColor Yellow
        exit 0
    }
}

# 检查远程仓库
Write-Host "`n🔗 检查远程仓库..." -ForegroundColor Yellow
$remoteUrl = git remote get-url origin 2>$null
if (-not $remoteUrl) {
    Write-Host "❌ 未找到远程仓库" -ForegroundColor Red
    Write-Host "请先添加远程仓库：git remote add origin https://github.com/timtoday/mcp-windows-notify.git" -ForegroundColor White
    exit 1
}
Write-Host "✅ 远程仓库: $remoteUrl" -ForegroundColor Green

# 检查标签是否已存在
Write-Host "`n🏷️  检查标签..." -ForegroundColor Yellow
$existingTag = git tag -l $tagName
if ($existingTag) {
    Write-Host "⚠️  标签 $tagName 已存在" -ForegroundColor Yellow
    $response = Read-Host "是否删除现有标签并重新创建？ (y/N)"
    if ($response -eq "y" -or $response -eq "Y") {
        Write-Host "删除本地标签..." -ForegroundColor Gray
        git tag -d $tagName
        Write-Host "删除远程标签..." -ForegroundColor Gray
        git push origin :refs/tags/$tagName 2>$null
    } else {
        Write-Host "已取消" -ForegroundColor Yellow
        exit 0
    }
}

# 创建标签
Write-Host "`n📝 创建标签 $tagName..." -ForegroundColor Yellow
git tag -a $tagName -m "$Message"
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ 创建标签失败" -ForegroundColor Red
    exit 1
}
Write-Host "✅ 标签创建成功" -ForegroundColor Green

# 推送标签到远程仓库
Write-Host "`n🚀 推送标签到GitHub..." -ForegroundColor Yellow
git push origin $tagName
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ 推送标签失败" -ForegroundColor Red
    Write-Host "请检查网络连接和GitHub权限" -ForegroundColor White
    exit 1
}
Write-Host "✅ 标签推送成功" -ForegroundColor Green

# 显示下一步操作
Write-Host "`n🎯 下一步操作:" -ForegroundColor Cyan
Write-Host "1. 访问GitHub Release页面:" -ForegroundColor White
Write-Host "   https://github.com/timtoday/mcp-windows-notify/releases" -ForegroundColor Gray
Write-Host ""
Write-Host "2. 点击 'Create a new release'" -ForegroundColor White
Write-Host ""
Write-Host "3. 选择标签: $tagName (应该已经可见)" -ForegroundColor White
Write-Host ""
Write-Host "4. 填写Release信息:" -ForegroundColor White
Write-Host "   - Title: $tagName - Initial Release" -ForegroundColor Gray
Write-Host "   - Description: 复制下面的内容" -ForegroundColor Gray

Write-Host "`n📋 Release描述模板:" -ForegroundColor Cyan
$releaseDescription = @"
## 🎉 MCP Windows通知插件首次发布！

### ✨ 主要功能
- Windows原生系统通知支持
- MCP协议完整实现
- 支持npx直接使用：``npx -y mcp-windows-notify``
- 多种通知类型（信息、警告、错误、成功）
- 可配置声音和显示时长

### 🚀 使用方法
在您的MCP配置中添加：
``````json
{
  "mcpServers": {
    "windows-notify": {
      "command": "npx",
      "args": ["-y", "mcp-windows-notify"]
    }
  }
}
``````

### 📦 安装方式
- 直接使用：``npx mcp-windows-notify``
- 全局安装：``npm install -g mcp-windows-notify``
"@

Write-Host $releaseDescription -ForegroundColor Gray

Write-Host "`n🔍 验证标签创建:" -ForegroundColor Yellow
Write-Host "本地标签:" -ForegroundColor White
git tag -l | Where-Object { $_ -like "v*" } | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }

Write-Host "`n✨ 标签创建完成！现在可以在GitHub上创建Release了。" -ForegroundColor Green
Write-Host "创建Release后，GitHub Actions会自动发布到NPM。" -ForegroundColor White
