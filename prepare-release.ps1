# 准备发布MCP Windows通知插件
Write-Host "准备发布MCP Windows通知插件..." -ForegroundColor Green

# 清理旧的构建文件
Write-Host "清理旧的构建文件..." -ForegroundColor Yellow
if (Test-Path "dist") {
    Remove-Item -Recurse -Force "dist"
}

# 重新构建
Write-Host "重新构建项目..." -ForegroundColor Yellow
npm run build

if ($LASTEXITCODE -ne 0) {
    Write-Host "构建失败!" -ForegroundColor Red
    exit 1
}

# 检查必要文件
Write-Host "检查必要文件..." -ForegroundColor Yellow
$requiredFiles = @("dist/index.js", "package.json", "README.md")
foreach ($file in $requiredFiles) {
    if (-not (Test-Path $file)) {
        Write-Host "缺少必要文件: $file" -ForegroundColor Red
        exit 1
    }
}

# 验证package.json配置
Write-Host "验证package.json配置..." -ForegroundColor Yellow
$packageJson = Get-Content "package.json" | ConvertFrom-Json
if (-not $packageJson.bin) {
    Write-Host "错误: package.json缺少bin配置" -ForegroundColor Red
    exit 1
}

# 测试本地安装
Write-Host "测试本地安装..." -ForegroundColor Yellow
npm install -g . --force

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ 本地安装测试成功" -ForegroundColor Green
} else {
    Write-Host "❌ 本地安装测试失败" -ForegroundColor Red
    exit 1
}

Write-Host "`n🎉 发布准备完成!" -ForegroundColor Green
Write-Host "现在可以:" -ForegroundColor Yellow
Write-Host "1. 发布到npm: npm publish" -ForegroundColor White
Write-Host "2. 或直接使用本地版本: npx mcp-windows-notify" -ForegroundColor White
Write-Host "`nMCP配置示例:" -ForegroundColor Yellow
Write-Host @"
{
  "mcpServers": {
    "windows-notify": {
      "command": "npx",
      "args": ["-y", "mcp-windows-notify"]
    }
  }
}
"@ -ForegroundColor White
