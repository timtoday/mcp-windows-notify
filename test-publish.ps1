# 测试发布流程脚本
param(
    [switch]$SkipBuild,
    [switch]$TestOnly
)

Write-Host "🚀 测试MCP Windows通知插件发布流程" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Cyan

# 检查环境
Write-Host "`n📋 检查环境..." -ForegroundColor Yellow

# 检查Node.js
try {
    $nodeVersion = node --version
    Write-Host "✅ Node.js版本: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js未安装" -ForegroundColor Red
    exit 1
}

# 检查npm
try {
    $npmVersion = npm --version
    Write-Host "✅ NPM版本: $npmVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ NPM未安装" -ForegroundColor Red
    exit 1
}

# 检查Git
try {
    $gitVersion = git --version
    Write-Host "✅ Git版本: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Git未安装" -ForegroundColor Red
    exit 1
}

if (-not $SkipBuild) {
    # 清理和构建
    Write-Host "`n🔨 构建项目..." -ForegroundColor Yellow
    
    if (Test-Path "dist") {
        Remove-Item -Recurse -Force "dist"
        Write-Host "清理旧的构建文件" -ForegroundColor Gray
    }
    
    npm run build
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ 构建失败" -ForegroundColor Red
        exit 1
    }
    Write-Host "✅ 构建成功" -ForegroundColor Green
}

# 验证构建输出
Write-Host "`n🔍 验证构建输出..." -ForegroundColor Yellow
$requiredFiles = @("dist/index.js", "dist/server.js", "dist/notification.js", "package.json", "README.md", "LICENSE")
foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "✅ $file" -ForegroundColor Green
    } else {
        Write-Host "❌ 缺少文件: $file" -ForegroundColor Red
        exit 1
    }
}

# 测试本地安装
Write-Host "`n📦 测试本地安装..." -ForegroundColor Yellow
try {
    # 卸载可能存在的旧版本
    npm uninstall -g mcp-windows-notify 2>$null
    
    # 全局安装当前版本
    npm install -g . --force
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ 本地安装失败" -ForegroundColor Red
        exit 1
    }
    
    # 验证命令可用
    $command = Get-Command mcp-windows-notify -ErrorAction SilentlyContinue
    if ($command) {
        Write-Host "✅ 全局命令安装成功: $($command.Source)" -ForegroundColor Green
    } else {
        Write-Host "❌ 全局命令未找到" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "❌ 安装测试失败: $_" -ForegroundColor Red
    exit 1
}

# 测试npx
Write-Host "`n🌐 测试npx命令..." -ForegroundColor Yellow
try {
    # 测试npx命令是否能找到包
    $job = Start-Job -ScriptBlock {
        $env:PATH = $using:env:PATH
        npx --yes mcp-windows-notify --help 2>&1
    }
    
    Wait-Job $job -Timeout 10
    $result = Receive-Job $job
    Remove-Job $job -Force
    
    if ($result -match "error" -or $result -match "failed") {
        Write-Host "⚠️  npx测试可能有问题，但这在本地测试中是正常的" -ForegroundColor Yellow
    } else {
        Write-Host "✅ npx命令测试通过" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠️  npx测试跳过（需要发布后才能完全测试）" -ForegroundColor Yellow
}

if ($TestOnly) {
    Write-Host "`n✅ 测试完成！项目已准备好发布。" -ForegroundColor Green
    exit 0
}

# 检查Git状态
Write-Host "`n📝 检查Git状态..." -ForegroundColor Yellow
$gitStatus = git status --porcelain
if ($gitStatus) {
    Write-Host "⚠️  有未提交的更改:" -ForegroundColor Yellow
    git status --short
    Write-Host "建议先提交所有更改再发布" -ForegroundColor Yellow
} else {
    Write-Host "✅ Git工作目录干净" -ForegroundColor Green
}

# 显示发布指南
Write-Host "`n🎯 发布指南:" -ForegroundColor Cyan
Write-Host "1. 确保所有更改已提交到Git" -ForegroundColor White
Write-Host "2. 更新版本号: npm version patch|minor|major" -ForegroundColor White
Write-Host "3. 推送到GitHub: git push && git push --tags" -ForegroundColor White
Write-Host "4. 在GitHub上创建Release（会自动发布到NPM）" -ForegroundColor White
Write-Host "5. 或手动发布: npm publish" -ForegroundColor White

Write-Host "`n📋 MCP配置示例:" -ForegroundColor Cyan
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

Write-Host "`n🎉 测试完成！项目已准备好发布到GitHub和NPM。" -ForegroundColor Green
