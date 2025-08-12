export interface NotificationConfig {
  title?: string;
  message: string;
  sound?: boolean;
  timeout?: number;
  icon?: 'info' | 'warning' | 'error' | 'success';
  subtitle?: string;
  actions?: string[];
}

export interface NotificationResult {
  success: boolean;
  message: string;
  timestamp: string;
}

export interface ServerConfig {
  name: string;
  version: string;
  notificationDefaults: {
    title: string;
    sound: boolean;
    timeout: number;
    icon: 'info' | 'warning' | 'error' | 'success';
  };
}
