# 测试npx命令是否正常工作
Write-Host "测试MCP Windows通知插件的npx命令..." -ForegroundColor Green

Write-Host "1. 测试全局安装的命令..." -ForegroundColor Yellow
try {
    $result = where mcp-windows-notify
    Write-Host "✅ 全局命令已安装: $result" -ForegroundColor Green
} catch {
    Write-Host "❌ 全局命令未找到" -ForegroundColor Red
}

Write-Host "`n2. 测试npx命令..." -ForegroundColor Yellow
Write-Host "注意: 这将启动MCP服务器，按Ctrl+C停止" -ForegroundColor Cyan
Write-Host "等待5秒后自动停止..." -ForegroundColor Gray

# 启动服务器进程
$job = Start-Job -ScriptBlock {
    npx -y mcp-windows-notify
}

# 等待5秒
Start-Sleep -Seconds 5

# 停止进程
Stop-Job $job -Force
Remove-Job $job -Force

Write-Host "✅ npx命令测试完成" -ForegroundColor Green
Write-Host "`n现在您可以在MCP配置中使用:" -ForegroundColor Yellow
Write-Host 'npx -y mcp-windows-notify' -ForegroundColor White
