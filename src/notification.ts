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
        actions: options.actions,
        wait: false // 不等待用户交互
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
   * 获取图标路径
   */
  private getIconPath(icon: string): string {
    // Windows系统图标路径
    const iconMap: Record<string, string> = {
      'info': 'C:\\Windows\\System32\\imageres.dll,76',
      'warning': 'C:\\Windows\\System32\\imageres.dll,78',
      'error': 'C:\\Windows\\System32\\imageres.dll,93',
      'success': 'C:\\Windows\\System32\\imageres.dll,77'
    };
    
    return iconMap[icon] || iconMap['info'];
  }

  /**
   * 发送任务完成通知
   */
  async notifyTaskComplete(taskName: string, details?: string): Promise<NotificationResult> {
    return this.sendNotification({
      title: '任务完成',
      message: `${taskName}${details ? '\n' + details : ''}`,
      icon: 'success',
      sound: true
    });
  }

  /**
   * 发送错误通知
   */
  async notifyError(errorMessage: string, details?: string): Promise<NotificationResult> {
    return this.sendNotification({
      title: '发生错误',
      message: `${errorMessage}${details ? '\n' + details : ''}`,
      icon: 'error',
      sound: true
    });
  }

  /**
   * 发送提醒通知
   */
  async notifyReminder(message: string, subtitle?: string): Promise<NotificationResult> {
    return this.sendNotification({
      title: '提醒',
      message,
      subtitle,
      icon: 'info',
      sound: true
    });
  }
}
