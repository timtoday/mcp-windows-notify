import { ServerConfig } from './types.js';

// 从环境变量加载配置
export const loadConfig = (): ServerConfig => {
  return {
    name: process.env.MCP_SERVER_NAME || 'windows-notify',
    version: process.env.MCP_SERVER_VERSION || '1.0.0',
    notificationDefaults: {
      title: process.env.NOTIFICATION_TITLE || '🤖 AI助手通知',
      sound: process.env.NOTIFICATION_SOUND !== 'false', // 默认开启声音
      timeout: parseInt(process.env.NOTIFICATION_TIMEOUT || '0'), // 0表示常驻，直到用户关闭
      icon: (process.env.NOTIFICATION_ICON as any) || 'info'
    }
  };
};

export const config = loadConfig();
