# 检查MCP Windows通知插件发布状态
param(
    [string]$PackageName = "mcp-windows-notify",
    [string]$GitHubRepo = "timtoday/mcp-windows-notify"
)

Write-Host "🔍 检查MCP Windows通知插件发布状态" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan

# 检查NPM包状态
Write-Host "`n📦 检查NPM包状态..." -ForegroundColor Yellow
try {
    $npmInfo = npm view $PackageName --json 2>$null | ConvertFrom-Json
    if ($npmInfo) {
        Write-Host "✅ NPM包已发布!" -ForegroundColor Green
        Write-Host "   包名: $($npmInfo.name)" -ForegroundColor White
        Write-Host "   版本: $($npmInfo.version)" -ForegroundColor White
        Write-Host "   描述: $($npmInfo.description)" -ForegroundColor White
        Write-Host "   主页: $($npmInfo.homepage)" -ForegroundColor White
        Write-Host "   发布时间: $($npmInfo.time.modified)" -ForegroundColor White
        
        # 测试npx命令
        Write-Host "`n🧪 测试npx命令..." -ForegroundColor Yellow
        $testJob = Start-Job -ScriptBlock {
            param($pkg)
            try {
                $result = npx --yes $pkg --help 2>&1
                return @{success = $true; output = $result}
            } catch {
                return @{success = $false; error = $_.Exception.Message}
            }
        } -ArgumentList $PackageName
        
        Wait-Job $testJob -Timeout 30 | Out-Null
        $testResult = Receive-Job $testJob
        Remove-Job $testJob -Force
        
        if ($testResult.success) {
            Write-Host "✅ npx命令测试成功!" -ForegroundColor Green
        } else {
            Write-Host "⚠️  npx命令测试可能有问题" -ForegroundColor Yellow
        }
        
    } else {
        Write-Host "❌ NPM包未找到" -ForegroundColor Red
        Write-Host "   可能原因:" -ForegroundColor Yellow
        Write-Host "   - 包尚未发布到NPM" -ForegroundColor White
        Write-Host "   - 包名不正确" -ForegroundColor White
        Write-Host "   - 发布过程中出现错误" -ForegroundColor White
    }
} catch {
    Write-Host "❌ 无法检查NPM包状态: $($_.Exception.Message)" -ForegroundColor Red
}

# 检查GitHub仓库状态
Write-Host "`n🐙 检查GitHub仓库状态..." -ForegroundColor Yellow
try {
    $repoUrl = "https://api.github.com/repos/$GitHubRepo"
    $repoInfo = Invoke-RestMethod -Uri $repoUrl -ErrorAction Stop
    
    Write-Host "✅ GitHub仓库存在!" -ForegroundColor Green
    Write-Host "   仓库: $($repoInfo.full_name)" -ForegroundColor White
    Write-Host "   描述: $($repoInfo.description)" -ForegroundColor White
    Write-Host "   主页: $($repoInfo.homepage)" -ForegroundColor White
    Write-Host "   星标: $($repoInfo.stargazers_count)" -ForegroundColor White
    Write-Host "   最后更新: $($repoInfo.updated_at)" -ForegroundColor White
    
    # 检查最新Release
    try {
        $releaseUrl = "https://api.github.com/repos/$GitHubRepo/releases/latest"
        $releaseInfo = Invoke-RestMethod -Uri $releaseUrl -ErrorAction Stop
        
        Write-Host "`n🏷️  最新Release信息:" -ForegroundColor Yellow
        Write-Host "   版本: $($releaseInfo.tag_name)" -ForegroundColor White
        Write-Host "   标题: $($releaseInfo.name)" -ForegroundColor White
        Write-Host "   发布时间: $($releaseInfo.published_at)" -ForegroundColor White
        Write-Host "   下载次数: $($releaseInfo.assets | Measure-Object -Property download_count -Sum | Select-Object -ExpandProperty Sum)" -ForegroundColor White
        
    } catch {
        Write-Host "⚠️  未找到Release信息" -ForegroundColor Yellow
        Write-Host "   建议创建第一个Release来触发NPM发布" -ForegroundColor White
    }
    
    # 检查GitHub Actions状态
    try {
        $actionsUrl = "https://api.github.com/repos/$GitHubRepo/actions/runs?per_page=5"
        $actionsInfo = Invoke-RestMethod -Uri $actionsUrl -ErrorAction Stop
        
        if ($actionsInfo.workflow_runs.Count -gt 0) {
            Write-Host "`n⚡ 最近的GitHub Actions:" -ForegroundColor Yellow
            foreach ($run in $actionsInfo.workflow_runs[0..2]) {
                $status = switch ($run.conclusion) {
                    "success" { "✅" }
                    "failure" { "❌" }
                    "cancelled" { "⏹️" }
                    default { "🔄" }
                }
                Write-Host "   $status $($run.name) - $($run.status) ($($run.created_at))" -ForegroundColor White
            }
        } else {
            Write-Host "⚠️  未找到GitHub Actions运行记录" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "⚠️  无法获取GitHub Actions信息" -ForegroundColor Yellow
    }
    
} catch {
    Write-Host "❌ GitHub仓库不存在或无法访问" -ForegroundColor Red
    Write-Host "   请确保仓库已创建: https://github.com/$GitHubRepo" -ForegroundColor White
}

# 显示使用说明
Write-Host "`n📋 使用说明:" -ForegroundColor Cyan
Write-Host "如果NPM包已发布，用户可以通过以下方式使用:" -ForegroundColor White
Write-Host @"
{
  "mcpServers": {
    "windows-notify": {
      "command": "npx",
      "args": ["-y", "$PackageName"]
    }
  }
}
"@ -ForegroundColor Gray

Write-Host "`n🔗 相关链接:" -ForegroundColor Cyan
Write-Host "   NPM包: https://www.npmjs.com/package/$PackageName" -ForegroundColor White
Write-Host "   GitHub: https://github.com/$GitHubRepo" -ForegroundColor White
Write-Host "   Releases: https://github.com/$GitHubRepo/releases" -ForegroundColor White
Write-Host "   Actions: https://github.com/$GitHubRepo/actions" -ForegroundColor White

Write-Host "`n✨ 检查完成!" -ForegroundColor Green
