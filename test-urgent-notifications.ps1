# 测试醒目通知功能
Write-Host "🔔 测试醒目通知功能" -ForegroundColor Green
Write-Host "===================" -ForegroundColor Cyan

# 构建项目
Write-Host "`n🔨 构建项目..." -ForegroundColor Yellow
npm run build
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ 构建失败" -ForegroundColor Red
    exit 1
}

# 创建测试脚本
$testScript = @'
import { WindowsNotifier } from './notification.js';

async function testUrgentNotifications() {
  console.log('🔔 开始测试醒目通知功能...\n');
  
  const notifier = new WindowsNotifier();
  
  // 测试1: AI工作完成通知
  console.log('1. 测试AI工作完成通知（常驻）...');
  await notifier.notifyAIWorkComplete(
    '代码生成',
    '已成功生成React组件代码，包含TypeScript类型定义'
  );
  
  // 等待用户查看
  await new Promise(resolve => {
    console.log('   请查看通知效果，按任意键继续...');
    process.stdin.once('data', () => resolve());
  });
  
  // 测试2: 醒目的任务完成通知
  console.log('\n2. 测试醒目任务完成通知...');
  await notifier.notifyTaskComplete(
    '文档编写完成',
    '已生成完整的API文档，请查看并确认'
  );
  
  await new Promise(resolve => {
    console.log('   请查看通知效果，按任意键继续...');
    process.stdin.once('data', () => resolve());
  });
  
  // 测试3: 醒目的错误通知
  console.log('\n3. 测试醒目错误通知...');
  await notifier.notifyError(
    '编译失败',
    '发现3个TypeScript类型错误，需要修复'
  );
  
  await new Promise(resolve => {
    console.log('   请查看通知效果，按任意键继续...');
    process.stdin.once('data', () => resolve());
  });
  
  // 测试4: 开发工具状态通知
  console.log('\n4. 测试开发工具状态通知...');
  await notifier.notifyDevToolStatus(
    'success',
    '代码格式化完成，所有文件已优化'
  );
  
  await new Promise(resolve => {
    console.log('   请查看通知效果，按任意键继续...');
    process.stdin.once('data', () => resolve());
  });
  
  // 测试5: 自定义醒目通知
  console.log('\n5. 测试自定义醒目通知...');
  await notifier.sendUrgentNotification({
    title: '🚨 重要提醒',
    message: '您的AI助手已完成所有任务\n请查看结果并继续您的工作\n\n此通知将常驻直到您点击关闭',
    icon: 'warning',
    sound: true
  });
  
  console.log('\n✨ 所有测试完成！');
  console.log('注意：通知现在会常驻在屏幕上，直到您手动关闭');
}

testUrgentNotifications().catch(error => {
  console.error('测试失败:', error);
  process.exit(1);
});
'@

# 保存测试脚本
$testScript | Out-File -FilePath "dist/test-urgent.js" -Encoding UTF8

Write-Host "✅ 构建完成" -ForegroundColor Green

Write-Host "`n🧪 运行醒目通知测试..." -ForegroundColor Yellow
Write-Host "注意：新的通知将会：" -ForegroundColor Cyan
Write-Host "  • 🔊 播放提示音" -ForegroundColor White
Write-Host "  • 📌 常驻在屏幕上" -ForegroundColor White
Write-Host "  • 🎨 使用醒目的图标和文字" -ForegroundColor White
Write-Host "  • 👆 需要用户点击才能关闭" -ForegroundColor White
Write-Host "  • ⚡ 包含操作按钮" -ForegroundColor White

$response = Read-Host "`n是否开始测试？ (y/N)"
if ($response -eq "y" -or $response -eq "Y") {
    Write-Host "`n🚀 开始测试..." -ForegroundColor Green
    node dist/test-urgent.js
} else {
    Write-Host "测试已取消" -ForegroundColor Yellow
}

Write-Host "`n📋 新增的通知工具:" -ForegroundColor Cyan
Write-Host "  • notify_ai_work_complete - AI工作完成通知" -ForegroundColor White
Write-Host "  • notify_dev_tool_status - 开发工具状态通知" -ForegroundColor White
Write-Host "  • send_urgent_notification - 醒目常驻通知" -ForegroundColor White

Write-Host "`n🎯 MCP配置示例:" -ForegroundColor Cyan
Write-Host @"
{
  "mcpServers": {
    "windows-notify": {
      "command": "npx",
      "args": ["-y", "mcp-windows-notify"],
      "env": {
        "NOTIFICATION_TIMEOUT": "0",
        "NOTIFICATION_SOUND": "true"
      }
    }
  }
}
"@ -ForegroundColor Gray
