import notifier from 'node-notifier';
import { NotificationConfig, NotificationResult } from './types.js';
import { config } from './config.js';

export class WindowsNotifier {
  /**
   * 发送Windows系统通知
   */
  async sendNotification(options: NotificationConfig): Promise<NotificationResult> {
    try {
      const notificationOptions = {
        title: options.title || config.notificationDefaults.title,
        message: options.message,
        sound: options.sound !== undefined ? options.sound : config.notificationDefaults.sound,
        time: options.timeout || config.notificationDefaults.timeout,
        icon: this.getIconPath(options.icon || config.notificationDefaults.icon),
        subtitle: options.subtitle,
        actions: options.actions || ['确定', '关闭'], // 添加操作按钮
        wait: true, // 等待用户交互，让通知常驻
        sticky: true, // 粘性通知，不会自动消失
        urgency: 'critical', // 设置为关键级别
        category: 'im.received', // 设置通知类别
        appName: 'AI助手通知', // 应用名称
        id: Date.now().toString() // 唯一ID
      };

      return new Promise((resolve) => {
        notifier.notify(notificationOptions, (err, response, metadata) => {
          if (err) {
            resolve({
              success: false,
              message: `通知发送失败: ${err.message}`,
              timestamp: new Date().toISOString()
            });
          } else {
            resolve({
              success: true,
              message: '通知发送成功',
              timestamp: new Date().toISOString()
            });
          }
        });
      });
    } catch (error) {
      return {
        success: false,
        message: `通知发送异常: ${error instanceof Error ? error.message : String(error)}`,
        timestamp: new Date().toISOString()
      };
    }
  }

  /**
   * 获取图标路径 - 使用更醒目的图标
   */
  private getIconPath(icon: string): string {
    // Windows系统图标路径 - 选择更醒目的图标
    const iconMap: Record<string, string> = {
      'info': 'C:\\Windows\\System32\\imageres.dll,81', // 更醒目的信息图标
      'warning': 'C:\\Windows\\System32\\imageres.dll,78', // 警告图标
      'error': 'C:\\Windows\\System32\\imageres.dll,93', // 错误图标
      'success': 'C:\\Windows\\System32\\imageres.dll,77' // 成功图标
    };

    return iconMap[icon] || iconMap['info'];
  }

  /**
   * 发送醒目的通知 - 带有闪烁效果和强制关注
   */
  async sendUrgentNotification(options: NotificationConfig): Promise<NotificationResult> {
    // 先发送一个短暂的声音提醒
    if (options.sound !== false) {
      try {
        // 播放系统提示音
        const { exec } = await import('child_process');
        exec('powershell -c "[console]::beep(800,300); [console]::beep(1000,300)"');
      } catch (error) {
        // 忽略声音播放错误
      }
    }

    // 发送常驻通知
    return this.sendNotification({
      ...options,
      timeout: 0, // 0表示不自动消失
      sound: true,
      actions: ['✅ 确定', '❌ 关闭', '⏰ 稍后提醒']
    });
  }

  /**
   * 发送任务完成通知 - 醒目版本
   */
  async notifyTaskComplete(taskName: string, details?: string): Promise<NotificationResult> {
    return this.sendUrgentNotification({
      title: '🎉 任务完成！',
      message: `✅ ${taskName}${details ? '\n📋 ' + details : ''}\n\n👆 点击确定继续工作`,
      icon: 'success',
      sound: true,
      timeout: 0 // 常驻直到用户关闭
    });
  }

  /**
   * 发送错误通知 - 醒目版本
   */
  async notifyError(errorMessage: string, details?: string): Promise<NotificationResult> {
    return this.sendUrgentNotification({
      title: '❌ 发生错误！',
      message: `🚨 ${errorMessage}${details ? '\n📝 ' + details : ''}\n\n👆 请检查并处理错误`,
      icon: 'error',
      sound: true,
      timeout: 0 // 常驻直到用户关闭
    });
  }

  /**
   * 发送提醒通知 - 醒目版本
   */
  async notifyReminder(message: string, subtitle?: string): Promise<NotificationResult> {
    return this.sendUrgentNotification({
      title: '💡 重要提醒',
      message: `📢 ${message}${subtitle ? '\n📌 ' + subtitle : ''}\n\n👆 点击确定已知悉`,
      subtitle,
      icon: 'info',
      sound: true,
      timeout: 0 // 常驻直到用户关闭
    });
  }

  /**
   * 发送AI工作完成通知 - 特别醒目
   */
  async notifyAIWorkComplete(workType: string, details?: string): Promise<NotificationResult> {
    return this.sendUrgentNotification({
      title: '🤖 AI工作完成！',
      message: `🎯 ${workType}已完成${details ? '\n📊 ' + details : ''}\n\n🔔 请查看结果并继续您的工作\n👆 点击确定关闭通知`,
      icon: 'success',
      sound: true,
      timeout: 0,
      actions: ['✅ 查看结果', '⏰ 稍后查看', '❌ 关闭']
    });
  }

  /**
   * 发送开发工具状态通知
   */
  async notifyDevToolStatus(status: string, message: string): Promise<NotificationResult> {
    const iconType = status === 'success' ? 'success' : status === 'error' ? 'error' : 'warning';
    const emoji = status === 'success' ? '✅' : status === 'error' ? '❌' : '⚠️';

    return this.sendUrgentNotification({
      title: `${emoji} 开发工具状态`,
      message: `${emoji} ${message}\n\n👆 点击确定继续`,
      icon: iconType,
      sound: true,
      timeout: 0
    });
  }
}
