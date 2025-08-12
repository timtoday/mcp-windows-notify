# 推送MCP Windows通知插件到GitHub
Write-Host "🚀 推送MCP Windows通知插件到GitHub (timtoday/mcp-windows-notify)" -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Cyan

# 检查Git是否已安装
try {
    $gitVersion = git --version
    Write-Host "✅ Git版本: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Git未安装，请先安装Git" -ForegroundColor Red
    exit 1
}

# 检查是否已经是Git仓库
if (Test-Path ".git") {
    Write-Host "⚠️  检测到现有Git仓库" -ForegroundColor Yellow
    $response = Read-Host "是否要重新初始化Git仓库？这将删除现有的Git历史 (y/N)"
    if ($response -eq "y" -or $response -eq "Y") {
        Remove-Item -Recurse -Force ".git"
        Write-Host "已删除现有Git仓库" -ForegroundColor Yellow
    } else {
        Write-Host "保留现有Git仓库，跳过初始化" -ForegroundColor Yellow
        $skipInit = $true
    }
}

if (-not $skipInit) {
    # 初始化Git仓库
    Write-Host "`n📝 初始化Git仓库..." -ForegroundColor Yellow
    git init
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Git初始化失败" -ForegroundColor Red
        exit 1
    }
    
    # 设置默认分支为main
    git branch -M main
    Write-Host "✅ Git仓库初始化完成" -ForegroundColor Green
}

# 添加所有文件
Write-Host "`n📦 添加文件到Git..." -ForegroundColor Yellow
git add .
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ 添加文件失败" -ForegroundColor Red
    exit 1
}

# 检查Git配置
Write-Host "`n🔧 检查Git配置..." -ForegroundColor Yellow
$gitUser = git config user.name
$gitEmail = git config user.email

if (-not $gitUser) {
    Write-Host "⚠️  Git用户名未设置" -ForegroundColor Yellow
    $userName = Read-Host "请输入您的Git用户名"
    git config user.name "$userName"
}

if (-not $gitEmail) {
    Write-Host "⚠️  Git邮箱未设置" -ForegroundColor Yellow
    $userEmail = Read-Host "请输入您的Git邮箱"
    git config user.email "$userEmail"
}

Write-Host "Git用户: $(git config user.name) <$(git config user.email)>" -ForegroundColor Green

# 提交更改
Write-Host "`n💾 提交更改..." -ForegroundColor Yellow
git commit -m "Initial commit: MCP Windows Notify plugin

- Windows原生通知支持
- MCP协议完整实现
- NPX直接使用支持
- 自动化CI/CD配置
- 完整文档和发布指南"

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ 提交失败" -ForegroundColor Red
    exit 1
}

# 添加远程仓库
Write-Host "`n🔗 添加远程仓库..." -ForegroundColor Yellow
$remoteExists = git remote get-url origin 2>$null
if ($remoteExists) {
    Write-Host "远程仓库已存在: $remoteExists" -ForegroundColor Yellow
    $response = Read-Host "是否要更新远程仓库URL？ (y/N)"
    if ($response -eq "y" -or $response -eq "Y") {
        git remote set-url origin https://github.com/timtoday/mcp-windows-notify.git
        Write-Host "✅ 远程仓库URL已更新" -ForegroundColor Green
    }
} else {
    git remote add origin https://github.com/timtoday/mcp-windows-notify.git
    Write-Host "✅ 远程仓库已添加" -ForegroundColor Green
}

# 显示推送前的信息
Write-Host "`n📋 推送信息:" -ForegroundColor Cyan
Write-Host "仓库: https://github.com/timtoday/mcp-windows-notify.git" -ForegroundColor White
Write-Host "分支: main" -ForegroundColor White
Write-Host "文件数量: $(git ls-files | Measure-Object -Line | Select-Object -ExpandProperty Lines)" -ForegroundColor White

# 确认推送
Write-Host "`n⚠️  注意: 请确保您已在GitHub上创建了 'mcp-windows-notify' 仓库" -ForegroundColor Yellow
$response = Read-Host "是否现在推送到GitHub？ (y/N)"

if ($response -eq "y" -or $response -eq "Y") {
    Write-Host "`n🚀 推送到GitHub..." -ForegroundColor Yellow
    git push -u origin main
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "`n🎉 成功推送到GitHub!" -ForegroundColor Green
        Write-Host "仓库地址: https://github.com/timtoday/mcp-windows-notify" -ForegroundColor Cyan
        Write-Host "`n📋 下一步:" -ForegroundColor Yellow
        Write-Host "1. 访问 https://github.com/timtoday/mcp-windows-notify" -ForegroundColor White
        Write-Host "2. 检查仓库内容是否正确" -ForegroundColor White
        Write-Host "3. 设置NPM_TOKEN密钥用于自动发布" -ForegroundColor White
        Write-Host "4. 创建第一个Release来发布到NPM" -ForegroundColor White
    } else {
        Write-Host "`n❌ 推送失败!" -ForegroundColor Red
        Write-Host "可能的原因:" -ForegroundColor Yellow
        Write-Host "- GitHub仓库不存在，请先在GitHub上创建 'mcp-windows-notify' 仓库" -ForegroundColor White
        Write-Host "- 没有推送权限，请检查GitHub认证" -ForegroundColor White
        Write-Host "- 网络连接问题" -ForegroundColor White
    }
} else {
    Write-Host "`n📝 推送已取消" -ForegroundColor Yellow
    Write-Host "您可以稍后手动推送:" -ForegroundColor White
    Write-Host "git push -u origin main" -ForegroundColor Gray
}
